resource "azurerm_servicebus_namespace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  tags = var.tags
}

resource "azurerm_servicebus_topic" "this" {
  name         = var.topic_name
  namespace_id = azurerm_servicebus_namespace.this.id
}

resource "azurerm_servicebus_subscription" "db_subscriber" {
  name               = "db-subscriber"
  topic_id           = azurerm_servicebus_topic.this.id
  max_delivery_count = 3
}

resource "azurerm_servicebus_subscription" "notification_sub" {
  name               = "notification-sub"
  topic_id           = azurerm_servicebus_topic.this.id
  max_delivery_count = 3
}