---
name: terraform
description: Terraform commands for the aks-demo project. Use when making infrastructure changes, managing state, or working with modules.
---

# Terraform Skill

## Init

```bash
# Init with blob backend
cd terraform
terraform init \
  -backend-config="resource_group_name=rg-tfstate" \
  -backend-config="storage_account_name=sttfstateinfrablade" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=aks-demo.terraform.tfstate"
```

## Plan & Apply

```bash
# Plan
terraform plan

# Apply (auto-approve for pipeline use)
terraform apply -auto-approve

# Destroy
terraform destroy
```

## State

```bash
# List all resources in state
terraform state list

# Show specific resource
terraform state show module.aks.azurerm_kubernetes_cluster.this

# Move resource (after refactoring)
terraform state mv azurerm_kubernetes_cluster.aks module.aks.azurerm_kubernetes_cluster.this

# Remove resource from state (without destroying)
terraform state rm azurerm_resource_group.main

# Import existing resource into state
terraform import azurerm_resource_group.main /subscriptions/e43b5499-c541-4091-a074-c4dbc88d8358/resourceGroups/rg-aks-demo
```

## Modules

```bash
# Re-download modules
terraform get -update

# List installed modules
ls .terraform/modules/
```

## Formatting & Validation

```bash
# Format all files
terraform fmt -recursive

# Check formatting without changing
terraform fmt -check -recursive

# Validate configuration
terraform validate
```

## Environment Variables

```bash
# Set for local use
export ARM_CLIENT_ID="ddd37de3-5bfd-43da-b169-19ba0eac6611"
export ARM_TENANT_ID="047ca22f-eeee-4e25-b2ad-9ef446fdeb4b"
export ARM_SUBSCRIPTION_ID="e43b5499-c541-4091-a074-c4dbc88d8358"
export ARM_CLIENT_SECRET="<secret>"
export TF_TOKEN_app_terraform_io="<tfc-token>"
```
