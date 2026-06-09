# GitHub Actions Rules

## Pipeline Structure

The main pipeline is `.github/workflows/deploy.yml`.

### Jobs (in order)

```
PR checks (parallel):
├── unit-test        # pytest on app/tests/
├── checkov          # IaC security scan on terraform/
└── terraform-plan   # Posts plan as PR comment

On merge to main (sequential):
├── terraform-apply  # Applies infrastructure changes
├── build-push       # Builds Docker image → pushes to ACR
├── scan             # Trivy vulnerability scan
├── deploy-dev       # Deploys to AKS (automatic)
└── deploy-staging   # Deploys to AKS (requires approval)
```

### Authentication

Uses OIDC — no stored secrets needed:
```yaml
permissions:
  id-token: write
  contents: read
```

Federated credentials configured for:
- `main` branch
- `pull_request`
- `dev` environment
- `staging` environment

### Secrets Required

```
AZURE_CLIENT_ID       # SP app ID
AZURE_TENANT_ID       # Infrablade tenant
AZURE_SUBSCRIPTION_ID # splat-playground-sub
AZURE_CLIENT_SECRET   # SP secret (for Terraform)
TF_TOKEN              # Terraform Cloud token
```

## Image Tagging

Images are tagged with `github.sha`:
```yaml
--image demo-app:${{ github.sha }}
```

deployment.yaml uses `${IMAGE_TAG}` placeholder:
```yaml
image: acraksdemocap.azurecr.io/demo-app:${IMAGE_TAG}
```

Replaced in pipeline with:
```bash
sed -i "s|\${IMAGE_TAG}|${{ github.sha }}|g" k8s/deployment.yaml
```

## Useful Commands

```bash
# List workflow runs
gh run list

# Watch a run
gh run watch

# Re-run failed jobs
gh run rerun <run-id> --failed

# View run logs
gh run view <run-id> --log
```
