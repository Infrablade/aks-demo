---
name: azure-cli
description: Azure CLI commands for managing resources in the Infrablade splat-playground-sub subscription.
---

# Azure CLI Skill

## Authentication

```bash
# Login
az login

# Set subscription
az account set --subscription e43b5499-c541-4091-a074-c4dbc88d8358

# Show current account
az account show
```

## Resource Groups

```bash
# List resource groups
az group list --output table

# Create resource group
az group create --name rg-name --location uksouth

# Delete resource group
az group delete --name rg-name --yes
```

## AKS

```bash
# Get credentials
az aks get-credentials --resource-group rg-aks-demo --name aks-demo

# List clusters
az aks list --output table

# Show cluster
az aks show --resource-group rg-aks-demo --name aks-demo

# Scale node pool
az aks scale --resource-group rg-aks-demo --name aks-demo --node-count 2
```

## ACR

```bash
# Login to ACR
az acr login --name acraksdemocap

# List repositories
az acr repository list --name acraksdemocap --output table

# List tags for an image
az acr repository show-tags --name acraksdemocap --repository demo-app --output table

# Build and push image
az acr build --registry acraksdemocap --image demo-app:latest ./app
```

## Key Vault

```bash
# List secrets
az keyvault secret list --vault-name kv-aks-demo-cap --output table

# Get secret value
az keyvault secret show --vault-name kv-aks-demo-cap --name servicebus-connection-string

# Set secret
az keyvault secret set --vault-name kv-aks-demo-cap --name my-secret --value "value"

# Purge deleted vault
az keyvault purge --name kv-aks-demo-cap --location uksouth
```

## Service Bus

```bash
# List namespaces
az servicebus namespace list --resource-group rg-aks-demo --output table

# Get connection string
az servicebus namespace authorization-rule keys list \
  --resource-group rg-aks-demo \
  --namespace-name sb-aks-demo-cap \
  --name RootManageSharedAccessKey \
  --query primaryConnectionString
```

## Service Principals

```bash
# List service principals
az ad sp list --display-name sp-tf-aks-demo --output table

# Show SP details
az ad sp show --id ddd37de3-5bfd-43da-b169-19ba0eac6611

# Reset SP secret
az ad sp credential reset --id ddd37de3-5bfd-43da-b169-19ba0eac6611
```

## Blob Storage (State)

```bash
# List state file versions
az storage blob list \
  --account-name sttfstateinfrablade \
  --container-name tfstate \
  --include v \
  --auth-mode login \
  --output table

# Restore previous state version
az storage blob copy start \
  --account-name sttfstateinfrablade \
  --destination-container tfstate \
  --destination-blob aks-demo.terraform.tfstate \
  --source-uri "https://sttfstateinfrablade.blob.core.windows.net/tfstate/aks-demo.terraform.tfstate?versionId=<version-id>" \
  --auth-mode login
```
