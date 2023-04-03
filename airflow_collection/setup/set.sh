clusterName=${cluster:-airflow-cluster-name}
region=${region:-asia-east2}
k8sNamespace=${namespace:-airflow}
helmName=${name:-airflow}


up() {
  # cluster create step can last for minutes
  gcloud container clusters create ${clusterName} --machine-type n1-standard-4 --num-nodes 1 --region $region # TODO consider k8s autoscale here.
  gcloud container clusters get-credentials ${clusterName} --region $region
  kubectl create namespace ${k8sNamespace}
  
  helm repo add apache-airflow https://airflow.apache.org
  helm repo update
  # helm install/upgrade step can last for minutes
  helm upgrade --install ${helmName} apache-airflow/airflow -n ${k8sNamespace} --debug
  # By default, the Helm chart is configured to use the `CeleryExecutor` which is why there is a `airflow-worker` and `airflow-redis` service. 
    
  kubectl create secret generic airflow-postgresql -n ${k8sNamespace} --from-literal=password='postgres' --dry-run=client -o yaml | kubectl apply -f -
  
  helm show values apache-airflow/airflow > values.yaml
  # TODO manual edit to values.yaml 
  # - change `.executor` from `CeleryExecutor` to `LocalExecutor`
  # - change `.webserver.service.type` from `ClusterIP` to `LoadBalancer`
  
  helm upgrade --install airflow apache-airflow/airflow -n ${k8sNamespace} -f values.yaml --debug
  
}
down() {
  helm delete ${helmName} --namespace ${k8sNamespace}
  kubectl delete namespace ${k8sNamespace}

}
$@
