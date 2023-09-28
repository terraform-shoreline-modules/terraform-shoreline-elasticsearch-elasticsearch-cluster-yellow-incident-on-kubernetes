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