variable "keyvault_name" {
    description = "The name of the Key Vault to create. This name must be globally unique."
    type = string
}

variable "location" {
    description = "The Azure region where the Key Vault will be created."
    type = string
}
variable "resource_group_name" {
    description = "The name of the resource group in which to create the Key Vault."
    type = string
}

variable "service_principal_name" {
    description = "The name of the Service Principal to create for accessing the Key Vault."
    type = string
}

variable "service_principal_object_id" {
    description = "The Object ID of the Service Principal to assign access policies in the Key Vault."
    type = string
}
variable "service_principal_tenant_id" {
    description = "The Tenant ID of the Service Principal to assign access policies in the Key Vault."
    type = string
}