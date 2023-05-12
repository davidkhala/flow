# Airflow

# [API](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html#section/Trying-the-API)
- [Trigger a new DAG run](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html#operation/post_dag_run)
  - Request body
    - `dag_run_id`: If not provided, a value will be generated based on execution_date. Confirmed in Response
  - Response
    - `dag_run_id`
- [Get a DAG run](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html#operation/get_dag_run)
  - Response
    - `state`: DagState, one of Enum: `"queued"` `"running"` `"success"` `"failed"`
- [Clear a DAG run](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html#operation/clear_dag_run)
  - Clearing a task instance doesn’t delete the task instance record. Instead, it updates `max_tries` to `0` and sets the current task instance state to `None`, which causes the task to re-run.
