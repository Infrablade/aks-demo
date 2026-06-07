data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

# ── Module: AKS ───────────────────────────────────────────────
module "aks" {
  source  = "app.terraform.io/InfraBlade/aks-cluster/azurerm"
  version = "1.0.0"

  name                = var.aks_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

# ── Module: ACR ───────────────────────────────────────────────
module "acr" {
  source  = "app.terraform.io/InfraBlade/container-registry/azurerm"
  version = "1.0.0"

  name                 = var.acr_name
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  aks_kubelet_identity = module.aks.kubelet_identity

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

# ── Module: Key Vault ─────────────────────────────────────────
module "key_vault" {
  source  = "app.terraform.io/InfraBlade/key-vault/azurerm"
  version = "1.0.0"

  name                = "kv-aks-demo-cap"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sp_object_id        = data.azurerm_client_config.current.object_id
  user_object_id      = "8fa4e49e-2b62-4f81-8a19-d6764a7f9893"

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

# ── Module: Service Bus ───────────────────────────────────────
module "service_bus" {
  source  = "app.terraform.io/InfraBlade/service-bus/azurerm"
  version = "1.0.0"

  name                = "sb-aks-demo-cap"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  topic_name          = "tax-code-updates"

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

# ── Service Bus connection string → Key Vault ─────────────────
resource "azurerm_key_vault_secret" "sb_connection_string" {
  name         = "servicebus-connection-string"
  value        = module.service_bus.primary_connection_string
  key_vault_id = module.key_vault.id

  depends_on = [
    module.key_vault
  ]

  tags = {
    env     = "demo"
    team    = "platform"
    project = "aks-demo"
  }
}

# ── Azure Policy ──────────────────────────────────────────────
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

# ── PIM-style scoped access ───────────────────────────────────
resource "azurerm_role_assignment" "sp_contributor_rg" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = "f3b15a3e-a8de-4841-927d-d6c2bfe8202d"
  description          = "Scoped contributor access for sp-tf-aks-demo. In P2 tenant this would be PIM eligible assignment."
}