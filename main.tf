# Configure the Azure provider
data "azurerm_subscription" "current" {}

# Get the current Azure client configuration
data "azuread_service_principal" "gha" {
  client_id = var.gha_client_id
}

# Get the existing resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

# Provision the Service Principal
module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [
    azurerm_resource_group.rg1
  ]
}


# Assign Contributor role scoped to the resource group
resource "azurerm_role_assignment" "rolespn" {
  scope                = azurerm_resource_group.rg1.id
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal,
    azurerm_resource_group.rg1
  ]
}


# Provision the Key Vault
module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal
  ]
}

# Grant GitHub Actions SPN 'Key Vault Secrets Officer' role so Terraform can write secrets
resource "azurerm_role_assignment" "gha_keyvault_access" {
  scope                = module.keyvault.kv_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azuread_service_principal.gha.object_id

  depends_on = [
    module.keyvault
  ]
}

# Grant the created Service Principal 'Key Vault Secrets Officer' for runtime use
resource "azurerm_role_assignment" "spn_keyvault_access" {
  scope                = module.keyvault.kv_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.keyvault,
    module.ServicePrincipal
  ]
}

# Store the Service Principal credentials as a secret in Key Vault
resource "azurerm_key_vault_secret" "secret" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.kv_id

  depends_on = [
    module.keyvault,
    azurerm_role_assignment.gha_keyvault_access,
    azurerm_role_assignment.spn_keyvault_access
  ]
}

# Provision AKS cluster (with supported modules)
module "aks" {
  source                 = "./modules/aks"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  resource_group_name    = var.rgname
  cluster_name           = var.cluster_name
  node_pool_name         = var.node_pool_name
  key_vault_id           = module.keyvault.kv_id
  resource_group_id      = azurerm_resource_group.rg1.id

  depends_on = [
    module.ServicePrincipal,
    module.keyvault
  ]
}

# Output the AKS kubeconfig to a local file
resource "local_file" "kubeconfig" {
  depends_on = [
    module.aks
  ]
  filename = "./kubeconfig"
  content  = module.aks.config
}

# Provision ArgoCD in the AKS cluster
module "argocd" {
  source                  = "./modules/argocd"
  kube_host               = module.aks.kube_host
  client_certificate      = module.aks.client_certificate
  client_key              = module.aks.client_key
  cluster_ca_certificate  = module.aks.cluster_ca_certificate
  key_vault_id            = module.keyvault.kv_id

  depends_on = [
    module.aks,
  ]
}