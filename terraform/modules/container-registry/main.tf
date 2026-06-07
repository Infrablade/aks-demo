resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false

  tags = var.tags
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = var.aks_kubelet_identity
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.this.id
  skip_service_principal_aad_check = true
}