# Configure the backend for Terraform state storage in Azure
terraform {
  backend "azurerm" {
    resource_group_name  = "my-resource-group"
    storage_account_name = "tfbackendstate"
    container_name      = "tfstate"
    key                 = "dev.tfstate"
  }
}
