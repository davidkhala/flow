set -e
clusterName=${cluster:-airflow-cluster-name}
region=${region:-asia-east2}
k8sNamespace=${namespace:-airflow}
helmName=${name:-airflow}

upGKE() {
  # cluster create step can last for minutes
  gcloud container clusters create ${clusterName} --machine-type n1-standard-4 --num-nodes 1 --region $region # TODO consider k8s autoscale here.
  gcloud container clusters get-credentials ${clusterName} --region $region
  kubectl create namespace ${k8sNamespace}

}
helmRegister() {
  helm repo update
  helm repo add apache-airflow https://airflow.apache.org
}
airflowEmpty() {
  helm upgrade --install ${helmName} apache-airflow/airflow -n ${k8sNamespace} --debug
}
up() {
  upGKE
  helmRegister
  airflowLocalExecutor
}
down() {
  downAirflow
  kubectl delete namespace ${k8sNamespace}
  gcloud container clusters delete ${clusterName} --region $region -q

}
downAirflow() {
  helm delete ${helmName} --namespace ${k8sNamespace}
}
setLocal() {
  # http://localhost:8080/
  kubectl port-forward svc/${helmName}-webserver 8080:8080 --namespace ${k8sNamespace}
}

status() {
  kubectl get pods --namespace ${k8sNamespace}
  helm list --namespace ${k8sNamespace}
}
airflowLoadExamles() {
  helm upgrade --install ${helmName} apache-airflow/airflow --namespace ${k8sNamespace} --set-string "env[0].name=AIRFLOW__CORE__LOAD_EXAMPLES" --set-string "env[0].value=True"
}
airflowLocalExecutor() {
  # manual edit to values.yaml
  # - change `.executor` from `CeleryExecutor` to `LocalExecutor`
  # - change `.webserver.service.type` from `ClusterIP` to `LoadBalancer`
  curl -O https://raw.githubusercontent.com/davidkhala/flow/main/airflow/setup/value-change.yaml
  helm upgrade --install ${helmName} apache-airflow/airflow --namespace ${k8sNamespace} -f value-change.yaml --debug
}

$@
