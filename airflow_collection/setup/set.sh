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
upAirflow() {
  helm repo update
  helm repo add apache-airflow https://airflow.apache.org
  # helm install/upgrade step can last for minutes
  helm upgrade --install ${helmName} apache-airflow/airflow -n ${k8sNamespace} --debug
  # or use airflowHelmExamles()

}
upLocalhost() {
  upGKE
  upAirflow
  setLocal
}
update() {
  kubectl create secret generic airflow-postgresql -n ${k8sNamespace} --from-literal=password='postgres' --dry-run=client -o yaml | kubectl apply -f -

  helm show values apache-airflow/airflow >values.yaml
  # TODO manual edit to values.yaml
  # - change `.executor` from `CeleryExecutor` to `LocalExecutor`
  # - change `.webserver.service.type` from `ClusterIP` to `LoadBalancer`

  helm upgrade --install ${helmName} apache-airflow/airflow -n ${k8sNamespace} -f values.yaml --debug
}
down() {
  kubectl delete namespace ${k8sNamespace}
  gcloud container clusters delete ${clusterName} --region $region -q

}
downAirflow(){
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
airflowHelmExamles() {
  helm upgrade --install ${helmName} apache-airflow/airflow --namespace ${k8sNamespace} --set-string "env[0].name=AIRFLOW__CORE__LOAD_EXAMPLES" --set-string "env[0].value=True"
}

$@
