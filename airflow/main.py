from pendulum import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator

from airflow.dag_gen.create import create

# build a dag for each number in range(10)
for n in range(1, 4):
    dag_id = "loop_hello_world_{}".format(str(n))

    default_args = {"owner": "airflow", "start_date": datetime(2021, 1, 1)}

    schedule = "@daily"
    dag_number = n

    dag = create(dag_id, schedule, dag_number, default_args)

    globals()[dag_id] = dag