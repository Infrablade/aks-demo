resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.aks_name
  oidc_issuer_enabled = true        

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                      = "kv-aks-demo-cap"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

# Gives the SP (Terraform) admin access to manage secrets
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Gives YOUR personal account admin access to see secrets in portal
resource "azurerm_role_assignment" "kv_admin_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = "8fa4e49e-2b62-4f81-8a19-d6764a7f9893"
}

resource "azurerm_servicebus_namespace" "sb" {
  name                = "sb-aks-demo-cap"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

resource "azurerm_servicebus_topic" "tax_code_updates" {
  name         = "tax-code-updates"
  namespace_id = azurerm_servicebus_namespace.sb.id
}

resource "azurerm_servicebus_subscription" "db_subscriber" {
  name               = "db-subscriber"
  topic_id           = azurerm_servicebus_topic.tax_code_updates.id
  max_delivery_count = 3
}

resource "azurerm_servicebus_subscription" "notification_sub" {
  name               = "notification-sub"
  topic_id           = azurerm_servicebus_topic.tax_code_updates.id
  max_delivery_count = 3
}

data "azurerm_servicebus_namespace_authorization_rule" "sb_rule" {
  name                = "RootManageSharedAccessKey"
  namespace_id        = azurerm_servicebus_namespace.sb.id
}

resource "azurerm_key_vault_secret" "sb_connection_string" {
  name         = "servicebus-connection-string"
  value        = data.azurerm_servicebus_namespace_authorization_rule.sb_rule.primary_connection_string
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_role_assignment.kv_admin
  ]

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

# Policy 1 — Require tags on all resources
resource "azurerm_resource_group_policy_assignment" "require_tags" {
  name                 = "require-tags"
  resource_group_id    = azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"

  parameters = jsonencode({
    tagName = {
      value = "env"
    }
  })
}

# Policy 2 — Allowed VM sizes
resource "azurerm_resource_group_policy_assignment" "allowed_vm_sizes" {
  name                 = "allowed-vm-sizes"
  resource_group_id    = azurerm_resource_group.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"

  parameters = jsonencode({
    listOfAllowedSKUs = {
      value = [
        "Standard_B2s",
        "Standard_B4ms",
        "Standard_D2s_v5",
        "Standard_D4s_v5"
      ]
    }
  })
}

# ── PIM-style time-bound access ───────────────────────────────────────────────
# NOTE: In a P2-licensed tenant this would use azurerm_pim_eligible_role_assignment
# which adds: time-bound activation, approval workflow, MFA on activation,
# justification required, and full audit log.
# This implements the same least-privilege principle with a scoped role assignment.

resource "azurerm_role_assignment" "sp_contributor_rg" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = "f3b15a3e-a8de-4841-927d-d6c2bfe8202d"
  description          = "Scoped contributor access for sp-tf-aks-demo. In P2 tenant this would be PIM eligible assignment with 8hr max activation."
}