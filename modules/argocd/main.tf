# Deploy ArgoCD using Helm and store the admin password in Azure Key Vault
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.3.5"

  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

# Fetch ArgoCD initial admin password from Kubernetes (base64 encoded)
data "kubernetes_secret" "argocd_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [helm_release.argocd]
}

# Store the base64 string in Azure Key Vault
resource "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  value        = data.kubernetes_secret.argocd_admin_secret.data["password"]
  key_vault_id = var.key_vault_id

  depends_on = [
    data.kubernetes_secret.argocd_admin_secret
  ]
}
