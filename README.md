
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Elasticsearch Cluster Yellow Incident on Kubernetes
---

An Elasticsearch Cluster Yellow incident occurs when there is a degradation in the Elasticsearch cluster's health. This can lead to a decrease in performance and availability of the Elasticsearch service. The incident is triggered when the status of the Elasticsearch cluster changes to yellow, indicating that some primary or replica shards are unavailable. The incident requires immediate attention to restore the Elasticsearch service's health and prevent any further impact on the end-users.

### Parameters
```shell
export ELASTICSEARCH_POD_NAME="PLACEHOLDER"

export ELASTICSEARCH_CONTAINER_NAME="PLACEHOLDER"

export ELASTICSEARCH_NAMESPACE="PLACEHOLDER"

export ELASTICSEARCH_DEPLOYMENT_NAME="PLACEHOLDER"

export YOUR_ELASTICSEARCH_LABEL="PLACEHOLDER"

export NEW_REPLICA_COUNT="PLACEHOLDER"
```

## Debug

### Check the Elasticsearch cluster health
```shell
kubectl exec -it ${ELASTICSEARCH_POD_NAME} -- curl -X GET 'http://localhost:9200/_cluster/health?pretty'
```

### Check the Elasticsearch cluster status
```shell
kubectl exec -it ${ELASTICSEARCH_POD_NAME} -- curl -X GET 'http://localhost:9200/_cat/health?v'
```

### List the Elasticsearch indices and their statuses
```shell
kubectl exec -it ${ELASTICSEARCH_POD_NAME} -- curl -X GET 'http://localhost:9200/_cat/indices?v'
```

### List the Elasticsearch nodes and their statuses
```shell
kubectl exec -it ${ELASTICSEARCH_POD_NAME} -- curl -X GET 'http://localhost:9200/_cat/nodes?v'
```

### Check the Elasticsearch logs for any errors or warnings
```shell
kubectl logs ${ELASTICSEARCH_POD_NAME} ${ELASTICSEARCH_CONTAINER_NAME}
```

### Check the Kubernetes events for any related issues
```shell
kubectl get events --field-selector involvedObject.name=${ELASTICSEARCH_POD_NAME}
```

# Check the disk usage of the Elasticsearch cluster
```shell
kubectl -n $NAMESPACE exec -it $DEPLOYMENT_NAME -- df -h
```

### Network connectivity issues: Network connectivity issues between the Elasticsearch nodes can cause the primary and replica shards to become unavailable, leading to a yellow status.
```shell


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


```

## Repair

### Increase the number of nodes in the Elasticsearch cluster to improve the cluster's resilience and availability.
```shell
bash

#!/bin/bash



# Set the name of the Elasticsearch deployment

DEPLOYMENT_NAME=${ELASTICSEARCH_DEPLOYMENT_NAME}



# Set the name of the Kubernetes namespace where the deployment is running

NAMESPACE=${ELASTICSEARCH_NAMESPACE}



# Set the number of replicas to increase the deployment to

REPLICA_COUNT=${NEW_REPLICA_COUNT}



# Scale the Elasticsearch deployment to the desired number of replicas

kubectl scale deployment $DEPLOYMENT_NAME --namespace $NAMESPACE --replicas $REPLICA_COUNT



bash

./increase-elasticsearch-nodes.sh elasticsearch default 3


```