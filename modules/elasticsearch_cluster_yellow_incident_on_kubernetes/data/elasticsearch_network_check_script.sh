

#!/bin/bash



# Step 1: Check if Elasticsearch pods are running

echo "Checking if Elasticsearch pods are running..."

kubectl get pods -l app=${YOUR_ELASTICSEARCH_LABEL} | grep Running > /dev/null

if [ $? -eq 0 ]; then

  echo "Elasticsearch pods are running."

else

  echo "Elasticsearch pods are not running."

  exit 1

fi



# Step 2: Check if Elasticsearch nodes are connected

echo "Checking if Elasticsearch nodes are connected..."

kubectl exec ${ELASTICSEARCH_POD_NAME} -- curl -XGET 'http://localhost:9200/_cat/nodes' > /dev/null

if [ $? -eq 0 ]; then

  echo "Elasticsearch nodes are connected."

else

  echo "Elasticsearch nodes are not connected."

  exit 1

fi



# Step 3: Check if Elasticsearch cluster status is yellow

echo "Checking if Elasticsearch cluster status is yellow..."

kubectl exec ${ELASTICSEARCH_POD_NAME} -- curl -XGET 'http://localhost:9200/_cluster/health' | grep yellow > /dev/null

if [ $? -eq 0 ]; then

  echo "Elasticsearch cluster status is yellow."

else

  echo "Elasticsearch cluster status is not yellow."

  exit 1

fi



echo "The Elasticsearch cluster is experiencing network connectivity issues."