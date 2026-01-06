output "config" {
    description = "Kube config for the AKS cluster"
    value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}

output "kube_host" {
  description = "Kubernetes API server host"
  value       = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].host
}

output "client_certificate" {
  description = "Kubernetes client certificate"
  value       = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].client_certificate
}

output "client_key" {
  description = "Kubernetes client key"
  value       = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].client_key
}

output "cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  value       = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].cluster_ca_certificate
}



output "cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks-cluster.name
}

output "resource_group_name" {
  description = "The name of the Resource Group in which the AKS cluster is deployed."
  value       = azurerm_kubernetes_cluster.aks-cluster.resource_group_name
}
