output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region"
  value       = azurerm_resource_group.main.location
}

output "aks_name" {
  description = "AKS cluster name"
  value       = module.aks.name
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = module.acr.login_server
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = module.key_vault.uri
}

output "service_bus_name" {
  description = "Service Bus namespace name"
  value       = module.service_bus.name
}