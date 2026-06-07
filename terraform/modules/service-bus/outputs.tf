output "id" {
  description = "Service Bus namespace ID"
  value       = azurerm_servicebus_namespace.this.id
}

output "name" {
  description = "Service Bus namespace name"
  value       = azurerm_servicebus_namespace.this.name
}

output "primary_connection_string" {
  description = "Service Bus primary connection string"
  value       = azurerm_servicebus_namespace.this.default_primary_connection_string
  sensitive   = true
}