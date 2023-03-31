from typing import Callable

from airflow import DAG
from airflow.models.dag import ScheduleArg
from airflow.operators.python import PythonOperator


class DAGGenerator:
    dag: DAG

    def __init__(self, dag_id, schedule: ScheduleArg, default_args: dict):
        self.dag = DAG(dag_id, schedule, default_args)

    def add_task(self, python_callable_task: PythonOperator):
        self.dag.add_task(python_callable_task)

        return self.dag
