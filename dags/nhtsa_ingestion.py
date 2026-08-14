from __future__ import annotations

from airflow.decorators import dag, task
from airflow.providers.google.cloud.hooks.gcs import GCSHook
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from datetime import datetime
import requests
import json

FORD_MODELS = ["f-150", "explorer", "escape", "mustang", "edge"]
MODEL_YEARS = [2022, 2023, 2024, 2025, 2026]
BUCKET_NAME = "nhtsa-recall-pipeline-bronze"
PROJECT_ID = "nhtsa-recall-pipeline"

@dag(
    dag_id="nhtsa_recall_ingestion",
    schedule="@daily",
    start_date=datetime(2026, 8, 1),
    catchup=False,
    tags=["nhtsa", "ingestion", "bronze"],
)
def nhtsa_recall_ingestion():

    @task
    def fetch_recalls() -> list[dict]:
        all_recalls = []
        for model in FORD_MODELS:
            for year in MODEL_YEARS:
                try:
                    response = requests.get(
                        "https://api.nhtsa.gov/recalls/recallsByVehicle",
                        params={"make": "ford", "model": model, "modelYear": year},
                        timeout=30,
                    )
                    response.raise_for_status()
                except requests.exceptions.HTTPError as e:
                    print(f"Skipping ford/{model}/{year}: {e}")
                    continue

                for result in response.json().get("results", []):
                    result["_pulled_model"] = model
                    result["_pulled_model_year"] = year
                    all_recalls.append(result)
        return all_recalls

    @task
    def upload_to_bronze(recalls: list[dict], ds: str = None) -> str:
        hook = GCSHook(gcp_conn_id="google_cloud_default")
        object_name = f"nhtsa_recalls/{ds}/recalls.json"
        ndjson_payload = "\n".join(json.dumps(record) for record in recalls)
        hook.upload(
            bucket_name=BUCKET_NAME,
            object_name=object_name,
            data=ndjson_payload,
            mime_type="application/json",
        )
        print(f"Uploaded {len(recalls)} records to gs://{BUCKET_NAME}/{object_name}")
        return object_name

    load_to_bigquery = GCSToBigQueryOperator(
        task_id="load_to_bigquery",
        bucket=BUCKET_NAME,
        source_objects=["{{ ti.xcom_pull(task_ids='upload_to_bronze') }}"],
        destination_project_dataset_table=f"{PROJECT_ID}.nhtsa_silver.raw_recalls",
        source_format="NEWLINE_DELIMITED_JSON",
        write_disposition="WRITE_TRUNCATE",
        autodetect=True,
        gcp_conn_id="google_cloud_default",
    )

    upload_to_bronze(fetch_recalls()) >> load_to_bigquery


nhtsa_recall_ingestion()