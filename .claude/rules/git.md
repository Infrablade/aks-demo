# Git Rules

## Branch Naming

Always use these prefixes:
- `feat/` — new features
- `fix/` — bug fixes
- `chore/` — maintenance, deps, config
- `refactor/` — code restructuring
- `docs/` — documentation only

Examples:
- `feat/add-vat-calculator`
- `fix/image-tag-replacement`
- `chore/remove-debug-steps`
- `refactor/extract-aks-module`

## Commit Messages

Use conventional commits format:
```
<type>: <short description>

[optional body]
```

Types: feat, fix, chore, refactor, docs, test, ci

Examples:
- `feat: add National Insurance calculation`
- `fix: use envsubst for image tag replacement`
- `chore: remove debug steps from pipeline`
- `refactor: extract resources into Terraform modules`

## PR Workflow

NEVER push directly to main. Always:
1. Create a feature branch
2. Make changes
3. Push branch
4. Create PR via `gh pr create`
5. Wait for checks to pass
6. Merge via GitHub UI or `gh pr merge --squash`

## Useful Commands

```bash
# Start a new feature
git checkout main && git pull
git checkout -b feat/my-feature

# Stage and commit
git add .
git commit -m "feat: description"

# Push and create PR
git push -u origin feat/my-feature
gh pr create --title "feat: description" --body "Details"

# Check PR status
gh pr checks

# Merge when ready
gh pr merge --squash
```
