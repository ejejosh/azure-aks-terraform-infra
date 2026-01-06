variable "kube_host" {
  description = "The hostname (IP) of the Kubernetes cluster"
}
variable "client_certificate" {
  description = "The base64 encoded public client certificate used to secure communication with the cluster"
}
variable "client_key" {
  description = "The client key used to secure communication with the cluster"
}
variable "cluster_ca_certificate" {
  description = "The base64 encoded public certificate authority certificate used to secure communication with the cluster"
}

variable "key_vault_id" {
  description = "Azure Key Vault ID for storing ArgoCD admin password"
}
