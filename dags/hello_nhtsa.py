from airflow.decorators import dag, task
from datetime import datetime

@dag(
    dag_id="hello_nhtsa",
    schedule="@daily",
    start_date=datetime(2026, 8, 1),
    catchup=False,
    tags=["nhtsa", "phase2-learning"],
)
def hello_nhtsa():

    @task
    def say_hello():
        print("Hello from the NHTSA Recall Pipeline DAG!")

    @task
    def say_bye():
        print("Bye — this ran only after say_hello finished.")

    say_hello() >> say_bye()

hello_nhtsa()