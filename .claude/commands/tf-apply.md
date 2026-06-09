# /tf-apply Command

Run a full Terraform workflow — plan, create PR, and apply via pipeline.

## Usage

```
/tf-apply <description of infrastructure change>
```

## Examples

```
/tf-apply increase AKS node count to 2
/tf-apply add new Key Vault secret for database connection string
/tf-apply update allowed VM SKUs policy
/tf-apply add Application Insights resource
```

## What this command does

1. Makes the Terraform change
2. Runs `terraform plan` locally to verify
3. Creates a feature branch
4. Commits and pushes
5. Raises a PR — pipeline will post the plan as a PR comment
6. After your approval and merge — pipeline applies automatically

## Important notes

- State is stored in Azure Blob Storage (rg-tfstate)
- Modules are pulled from TFC private registry (app.terraform.io/InfraBlade)
- Terraform apply runs automatically in GitHub Actions after merge
- No manual terraform apply needed

## Backend config

```bash
terraform init \
  -backend-config="resource_group_name=rg-tfstate" \
  -backend-config="storage_account_name=sttfstateinfrablade" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=aks-demo.terraform.tfstate"
```

## Environment variables needed

```
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_TENANT_ID
ARM_SUBSCRIPTION_ID
TF_TOKEN_app_terraform_io
```
