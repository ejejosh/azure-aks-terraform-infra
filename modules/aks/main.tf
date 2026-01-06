# Generates a new TLS private key for the SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Stores the generated public SSH key in Azure Key Vault
resource "azurerm_key_vault_secret" "aks_public_key" {
  name         = "aks-ssh-public-key"
  value        = tls_private_key.ssh_key.public_key_openssh
  key_vault_id = var.key_vault_id
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                              = var.cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = "${var.resource_group_name}-cluster"
  kubernetes_version                = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group               = "${var.resource_group_name}-nrg"
  role_based_access_control_enabled = true

  default_node_pool {
    name                 = var.node_pool_name
    vm_size              = "Standard_D2s_v3"
    zones                = [1, 2, 3]
    auto_scaling_enabled = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
  }

  # Use managed identity for AKS instead of Service Principal
  identity {
    type = "SystemAssigned"
  }

  # Public key from the Key Vault secret
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = azurerm_key_vault_secret.aks_public_key.value
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}


# Assigning a contributor role to the AKS cluster's Kubelet identity
resource "azurerm_role_assignment" "aks_kubelet_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity[0].object_id

  depends_on = [
    azurerm_kubernetes_cluster.aks-cluster
  ]
}

# Granting AKS cluster's managed identity "Get" permissions for secrets
# to allow it to retrieve the SSH public key from Key Vault.
resource "azurerm_key_vault_access_policy" "aks_secret_read" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity[0].object_id

  secret_permissions = [
    "Get",
  ]

  depends_on = [
    azurerm_kubernetes_cluster.aks-cluster
  ]
}