output "resource_group_name" {
  description = "The name of the resource group"
  value = azurerm_resource_group.rg1.name
}

output "client_id" {
  description = "The application id of AzureAD application created."
  value       = module.ServicePrincipal.client_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = module.ServicePrincipal.client_secret
  sensitive = true

}
