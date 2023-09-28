resource "shoreline_notebook" "elasticsearch_cluster_yellow_incident_on_kubernetes" {
  name       = "elasticsearch_cluster_yellow_incident_on_kubernetes"
  data       = file("${path.module}/data/elasticsearch_cluster_yellow_incident_on_kubernetes.json")
  depends_on = [shoreline_action.invoke_elasticsearch_network_check_script,shoreline_action.invoke_increase_elasticsearch_nodes]
}

resource "shoreline_file" "elasticsearch_network_check_script" {
  name             = "elasticsearch_network_check_script"
  input_file       = "${path.module}/data/elasticsearch_network_check_script.sh"
  md5              = filemd5("${path.module}/data/elasticsearch_network_check_script.sh")
  description      = "Network connectivity issues: Network connectivity issues between the Elasticsearch nodes can cause the primary and replica shards to become unavailable, leading to a yellow status."
  destination_path = "/agent/scripts/elasticsearch_network_check_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_elasticsearch_nodes" {
  name             = "increase_elasticsearch_nodes"
  input_file       = "${path.module}/data/increase_elasticsearch_nodes.sh"
  md5              = filemd5("${path.module}/data/increase_elasticsearch_nodes.sh")
  description      = "Increase the number of nodes in the Elasticsearch cluster to improve the cluster's resilience and availability."
  destination_path = "/agent/scripts/increase_elasticsearch_nodes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_elasticsearch_network_check_script" {
  name        = "invoke_elasticsearch_network_check_script"
  description = "Network connectivity issues: Network connectivity issues between the Elasticsearch nodes can cause the primary and replica shards to become unavailable, leading to a yellow status."
  command     = "`chmod +x /agent/scripts/elasticsearch_network_check_script.sh && /agent/scripts/elasticsearch_network_check_script.sh`"
  params      = ["ELASTICSEARCH_POD_NAME","YOUR_ELASTICSEARCH_LABEL"]
  file_deps   = ["elasticsearch_network_check_script"]
  enabled     = true
  depends_on  = [shoreline_file.elasticsearch_network_check_script]
}

resource "shoreline_action" "invoke_increase_elasticsearch_nodes" {
  name        = "invoke_increase_elasticsearch_nodes"
  description = "Increase the number of nodes in the Elasticsearch cluster to improve the cluster's resilience and availability."
  command     = "`chmod +x /agent/scripts/increase_elasticsearch_nodes.sh && /agent/scripts/increase_elasticsearch_nodes.sh`"
  params      = ["ELASTICSEARCH_DEPLOYMENT_NAME","NEW_REPLICA_COUNT","ELASTICSEARCH_NAMESPACE","NAMESPACE"]
  file_deps   = ["increase_elasticsearch_nodes"]
  enabled     = true
  depends_on  = [shoreline_file.increase_elasticsearch_nodes]
}

