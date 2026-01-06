variable "location" {
  description = "Azure region for all resources."
  type        = string
}
 variable "resource_group_name" { 
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
 }

variable "resource_group_id" {
  description = "The ID of the resource group where AKS resides"
  type        = string
}

variable "service_principal_name" {
  description = "The name of the Service Principal to create for the AKS cluster."
  type = string
}

variable "ssh_public_key" {
  description = "Path to the SSH public key used for the AKS cluster nodes."
  type        = string
  default = ".ssh/id_rsa.pub"
}

variable "client_id" {
  description = "The Client ID of the Service Principal to use for the AKS cluster."
  type = string
}
variable "client_secret" {
  description = "The Client Secret of the Service Principal to use for the AKS cluster."
  type = string
  sensitive = true
}

variable "node_pool_name" {
  description = "The name of the default node pool."
  type        = string
}
variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Key Vault where the SSH public key will be stored."
  type        = string
}
