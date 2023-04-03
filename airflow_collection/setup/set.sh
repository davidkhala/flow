clusterName=${cluster:-airflow-cluster-name}
region=${region:-asia-east2}
k8sNamespace=${namespace:-airflow}
helmName=${name:-airflow}


up(){
  gcloud container clusters create ${clusterName} --machine-type n1-standard-4 --num-nodes 1 --region $region # TODO consider k8s autoscale here.
  gcloud container clusters get-credentials ${clusterName} --region $region
  kubectl create namespace ${k8sNamespace}
  helm repo add apache-airflow https://airflow.apache.org
  helm upgrade --install ${helmName} apache-airflow/airflow -n ${k8sNamespace} --debug
  # By default, the Helm chart is configured to use the `CeleryExecutor` which is why there is a `airflow-worker` and `airflow-redis` service. 
  
  
  
  
  
  # We will change this to the `LocalExecutor`.
  
}
down(){
  
}
$@
