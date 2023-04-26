from pendulum import datetime

from airflow_codegen import DAGGenerator

# build a dag for each number in range(10)
for n in range(1, 4):
    dag_id = "loop_hello_world_{}".format(str(n))

    default_args = {"owner": "airflow_codegen", "start_date": datetime(2021, 1, 1)}

    schedule = None
    dag_number = n

    dag = DAGGenerator(dag_id, schedule, default_args)

    globals()[dag_id] = dag