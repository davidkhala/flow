clusterName=${cluster:-airflow-cluster-name}
region=${region:-asia-east2}
k8sNamespace=${namespace:-airflow}


up(){
  gcloud container clusters create ${clusterName} --machine-type n1-standard-4 --num-nodes 1 --region $region # TODO consider k8s autoscale here.
  gcloud container clusters get-credentials ${clusterName} --region $region
  kubectl create namespace ${k8sNamespace}
  helm repo add apache-airflow https://airflow.apache.org
}
down(){
  
}
$@
