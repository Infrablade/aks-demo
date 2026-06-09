---
name: github-cli
description: GitHub CLI (gh) commands for pull requests, branches, workflows and releases on the Infrablade/aks-demo repo.
---

# GitHub CLI Skill

## Pull Requests

```bash
# List open PRs
gh pr list

# Create a PR
gh pr create --title "feat: description" --body "Details" --base main

# Create draft PR
gh pr create --draft --title "WIP: feature" --body "Details"

# View PR details
gh pr view <number>

# Check PR status checks
gh pr checks <number>

# Approve a PR
gh pr review <number> --approve

# Merge a PR (squash preferred)
gh pr merge <number> --squash

# Close a PR
gh pr close <number>
```

## Branches

```bash
# Create and switch to branch
git checkout -b feat/my-feature

# Push branch and set upstream
git push -u origin feat/my-feature

# List remote branches
git branch -r

# Delete remote branch
git push origin --delete feat/my-feature
```

## Workflows

```bash
# List workflows
gh workflow list

# List recent runs
gh run list

# Watch a run live
gh run watch

# Re-run failed jobs only
gh run rerun <run-id> --failed

# View run logs
gh run view <run-id> --log

# Trigger workflow manually
gh workflow run deploy.yml
```

## Releases

```bash
# List releases
gh release list

# Create release
gh release create v1.0.0 --title "Release v1.0.0" --generate-notes

# View release
gh release view v1.0.0
```

## Infrablade Specific

```bash
# Clone aks-demo
gh repo clone Infrablade/aks-demo

# View repo
gh repo view Infrablade/aks-demo

# List open PRs in aks-demo
gh pr list -R Infrablade/aks-demo

# My open PRs
gh search prs --author=@me --owner=Infrablade --state=open
```