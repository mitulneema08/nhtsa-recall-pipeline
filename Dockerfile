FROM apache/airflow:2.9.3

RUN pip install --no-cache-dir \
    apache-airflow-providers-google \
    requests \
    dbt-core==1.11.11 \
    dbt-bigquery==1.12.0

# Airflow's Celery worker breaks with click>=8.3.0 (documented compatibility bug).
# dbt-core requires click>=8.3.0, so force it back down after installing everything else.
RUN pip install --no-cache-dir click==8.2.1