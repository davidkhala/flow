clusterName=${cluster:-airflow-cluster-name}
region=${region:-asia-east2}

gcloud container clusters create ${clusterName} --machine-type n1-standard-4 --num-nodes 1 --region $region
gcloud container clusters get-credentials ${clusterName} --region $region
