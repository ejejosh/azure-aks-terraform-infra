output "kv_id" {
  description = "The ID of the created Key Vault."
  value       = azurerm_key_vault.kv.id
}