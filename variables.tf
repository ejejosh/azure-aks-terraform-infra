variable "rgname" {
  type        = string
  description = "The name of the resource group to create."

}
variable "gha_client_id" {
  description = "The client application ID of GitHub Actions service principal"
  type        = string
}
variable "location" {
  description = "The Azure region where resources will be created."
  type    = string
  default = "swedencentral"
}

variable "service_principal_name" {  
  description = "The name of the Service Principal to create for accessing the Key Vault and AKS cluster."
  type = string
}

variable "keyvault_name" {
  description = "The name of the Key Vault to create. This name must be globally unique."
  type = string
}
variable "node_pool_name" {
  description = "The name of the default node pool."
  type    = string
}
variable "cluster_name" {
  description = "The name of the AKS cluster."
  type    = string
}
