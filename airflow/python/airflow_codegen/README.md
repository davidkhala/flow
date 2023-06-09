# Airflow

## [Dynamically generate DAGs](https://docs.astronomer.io/learn/dynamically-generating-dags)(static codegen)


## Dynamic Tasks (codegen at runtime)
With the release of Airflow 2.3, you can write DAGs that dynamically generate parallel tasks at runtime. 
- This feature, known as dynamic task mapping, is a paradigm shift for DAG design in Airflow.

Prior to Airflow 2.3, tasks could only be generated dynamically at the time that the DAG was parsed, meaning you had to change your DAG code if you needed to adjust tasks based on some external factor. With dynamic task mapping, you can easily write DAGs that create tasks based on your current runtime environment.

In self guide, you'll learn about dynamic task mapping and complete an example implementation for a common use case.

# Connect
Default Webserver (Airflow UI) Login credentials:
- username: admin
- password: admin

Default Postgres connection credentials:
- username: postgres
- password: postgres
- port: 5432
