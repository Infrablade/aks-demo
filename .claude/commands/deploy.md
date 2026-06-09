# /deploy Command

Deploy a change to the aks-demo project via PR workflow.

## Usage

```
/deploy <description of change>
```

## Examples

```
/deploy update replica count to 3
/deploy bump flask to 3.1.0
/deploy add new /calculate-vat endpoint
/deploy increase memory limits on demo-app
```

## What this command does

1. Creates a feature branch from main
2. Makes the requested change
3. Runs relevant tests locally if possible
4. Commits with a conventional commit message
5. Pushes the branch
6. Creates a PR with a clear description
7. Reports the PR URL

## Workflow

```bash
# 1. Ensure we're on main and up to date
git checkout main
git pull

# 2. Create feature branch
git checkout -b feat/<slug-of-change>

# 3. Make the change
# ... (Claude makes the changes)

# 4. Commit
git add .
git commit -m "feat: <description>"

# 5. Push and raise PR
git push -u origin feat/<slug-of-change>
gh pr create --title "feat: <description>" --body "<details>"
```

## Pipeline checks that will run

- Unit Tests
- Checkov IaC Scan
- Terraform Plan (posted as PR comment)

All must pass before merging.
After merge:
- Terraform Apply
- Build & Push to ACR
- Trivy Scan
- Deploy to Dev (automatic)
- Deploy to Staging (requires your approval)
