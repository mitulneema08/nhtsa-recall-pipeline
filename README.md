# NHTSA Recall Pipeline

End-to-end data pipeline on GCP, built around the public NHTSA vehicle recall API. Combines hands-on Google Cloud data engineering (Terraform, Airflow, dbt, Pub/Sub, CI/CD) with real-world automotive recall domain expertise.

## Architecture

​```
NHTSA API → Cloud Functions → GCS (Bronze) → dbt → BigQuery (Silver) → dbt → BigQuery (Gold) → Power BI
​```

Medallion architecture: Bronze = raw landed data, Silver = cleaned/typed tables, Gold = analytics-ready marts.

## Stack
- **Ingestion:** Python, Cloud Functions
- **Infrastructure:** Terraform
- **Orchestration:** Apache Airflow
- **Transformation:** dbt
- **Streaming:** GCP Pub/Sub
- **CI/CD:** GitHub Actions
- **Dashboard:** Power BI

## Build status
- [ ] Environment setup (GCP project, GitHub repo)
- [ ] Ingestion (NHTSA API → GCS)
- [ ] Terraform (IaC for GCS + BigQuery)
- [ ] Airflow orchestration
- [ ] dbt transformations (Medallion)
- [ ] Pub/Sub streaming step
- [ ] CI/CD pipeline
- [ ] Power BI dashboard