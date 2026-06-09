# Terraform Rules

## Structure

```
terraform/
├── main.tf          # Root module - calls registry modules
├── variables.tf     # Input variables with defaults
├── outputs.tf       # Output values
├── versions.tf      # Provider versions + TFC cloud block
├── backend.tf       # Blob storage backend config (commented)
└── modules/         # Local modules (for reference)
    ├── aks-cluster/
    ├── container-registry/
    ├── key-vault/
    └── service-bus/
```

## Registry Modules

Always use TFC private registry modules:
```hcl
module "aks" {
  source  = "app.terraform.io/InfraBlade/aks-cluster/azurerm"
  version = "1.0.0"
}
```

Available modules:
- `app.terraform.io/InfraBlade/aks-cluster/azurerm`
- `app.terraform.io/InfraBlade/container-registry/azurerm`
- `app.terraform.io/InfraBlade/key-vault/azurerm`
- `app.terraform.io/InfraBlade/service-bus/azurerm`

## Backend

State is in Azure Blob Storage:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateinfrablade"
    container_name       = "tfstate"
    key                  = "aks-demo.terraform.tfstate"
  }
}
```

## Tagging

Always tag resources:
```hcl
tags = {
  env     = "demo"
  team    = "platform"
  project = "aks-demo"
}
```

## Workflow

```bash
# Init with backend config
terraform init \
  -backend-config="resource_group_name=rg-tfstate" \
  -backend-config="storage_account_name=sttfstateinfrablade" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=aks-demo.terraform.tfstate"

# Plan
terraform plan

# Apply (done automatically by pipeline after PR merge)
terraform apply
```

## State Management

```bash
# List resources in state
terraform state list

# Move resource (after refactoring)
terraform state mv old_address new_address

# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/rg-name

# List state versions in blob
az storage blob list \
  --account-name sttfstateinfrablade \
  --container-name tfstate \
  --include v \
  --auth-mode login \
  --output table
```
