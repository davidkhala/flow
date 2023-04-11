# Use Airflow as a python package (library)
Airflow installation can be tricky sometimes because Airflow is both a library and an application
- Only pip installation is currently officially supported.
- Installing via `Poetry` or `pip-tools` is not currently supported.
- Workaround: use the constraints and convert them to appropriate format and workflow that your tool requires.
  - `./install.sh`