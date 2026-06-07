resource "azurerm_key_vault" "this" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  tenant_id                 = var.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true

  tags = var.tags
}

resource "azurerm_role_assignment" "kv_admin_sp" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.sp_object_id
}

resource "azurerm_role_assignment" "kv_admin_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.user_object_id
}