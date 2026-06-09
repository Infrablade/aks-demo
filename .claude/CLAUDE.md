# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Repository Overview

**ai-skills** is Chris Pappas's personal Claude Code skills repository for the Infrablade organisation.
It contains shared AI agent skills, commands, and rules for platform engineering work.

## Installation

```bash
# Add the marketplace (one-time setup)
/plugin marketplace add Infrablade/ai-skills

# Install the platform-engineer plugin
/plugin install platform-engineer@infrablade-ai-skills
```

## Repository Structure

```
ai-skills/
├── agents/                    # Role-based AI personas
│   └── platform-engineer.md  # Platform engineering persona
├── commands/                  # Slash commands
│   ├── deploy.md              # /deploy - create PR and trigger pipeline
│   ├── pr.md                  # /pr - create a pull request
│   └── tf-apply.md            # /tf-apply - run terraform workflow
├── rules/                     # Behaviour rules for Claude Code
│   ├── git.md                 # Git conventions
│   ├── github-actions.md      # Pipeline conventions
│   └── terraform.md           # Terraform conventions
├── skills/                    # Knowledge libraries
│   ├── github-cli/            # gh CLI commands
│   ├── terraform/             # Terraform commands
│   ├── azure-cli/             # az CLI commands
│   └── kubernetes/            # kubectl commands
└── CLAUDE.md                  # This file
```

## Key Principles

- Always create a feature branch before making changes
- Always raise a PR — never push directly to main
- Always run terraform plan before apply
- Use conventional commits (feat:, fix:, chore:, refactor:)
- Wait for pipeline checks to pass before merging
