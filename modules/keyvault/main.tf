# Generate a random suffix to guarantee unique vault names 
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# Get the current Azure client configuration
resource "azurerm_key_vault" "kv" {
  name                        = "${var.keyvault_name}-${random_string.suffix.result}" 
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false
  sku_name                    = "premium"
  soft_delete_retention_days  = 7

  enable_rbac_authorization   = true
}
