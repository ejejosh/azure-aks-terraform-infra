# Datasource to get the latest Azure AKS version
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

# Datasource to get the current subscription ID
data "azurerm_subscription" "current" { 
}
