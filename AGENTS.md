# AGENTS.md

Guidance for AI agents working in this repository.

## Project Overview

**Azure Kubernetes Service Practical Guide** — a documentation hub for deploying and operating containerized applications on Azure Kubernetes Service (AKS).

- **Live site**: <https://yeongseon.github.io/azure-kubernetes-service-practical-guide/>
- **Repository**: <https://github.com/yeongseon/azure-kubernetes-service-practical-guide>

## Repository Structure

```text
.
├── .github/
│   └── workflows/              # GitHub Pages deployment
├── docs/
│   ├── assets/                 # Images, icons
│   ├── best-practices/         # Production patterns
│   ├── javascripts/            # Mermaid zoom JS
│   ├── operations/             # Day-2 operational tasks
│   ├── platform/               # Architecture and concepts
│   ├── start-here/             # Entry points
│   ├── stylesheets/            # Custom CSS
│   └── troubleshooting/        # Diagnosis and resolution
└── mkdocs.yml                  # MkDocs Material configuration
```

## Documentation Conventions

### File Naming

- All files: `topic-name.md` (kebab-case)

### CLI Command Style

```bash
# ALWAYS use long flags for readability
az aks create --resource-group $RG --name $CLUSTER_NAME --node-count 3

# NEVER use short flags in documentation
az aks create -g $RG -n $CLUSTER_NAME  # ❌ Don't do this
```

### Variable Naming Convention

| Variable | Description | Example |
|----------|-------------|---------|
| `$RG` | Resource group name | `rg-aks-demo` |
| `$CLUSTER_NAME` | AKS cluster name | `aks-demo` |
| `$LOCATION` | Azure region | `koreacentral` |

### Mermaid Diagrams

All architectural diagrams use Mermaid. Every documentation page should include at least one diagram.

### Tail Section Naming

Every document ends with these sections (in this order):

| Section | Purpose |
|---------|---------|
| `## See Also` | Internal cross-links within this repository |
| `## Sources` | External references (Microsoft Learn) |

## Build & Preview

```bash
pip install mkdocs-material mkdocs-minify-plugin
mkdocs build --strict
mkdocs serve
```

## Git Commit Style

```text
type: short description
```

Allowed types: `feat`, `fix`, `docs`, `chore`, `refactor`

## Tutorial Validation Tracking

Every tutorial document supports **validation frontmatter** that records when and how it was last tested against a real Azure deployment.

### Frontmatter Schema

Add a `validation` block inside the YAML frontmatter (`---` fences) of any tutorial file:

```yaml
---
hide:
  - toc
validation:
  az_cli:
    last_tested: 2026-04-09
    cli_version: "2.83.0"
    result: pass
  bicep:
    last_tested: null
    result: not_tested
---
```

### Agent Rules for Validation

1. **After deploying a tutorial end-to-end**, add or update the `validation` frontmatter with the current date, CLI version, and `result: pass`.
2. **If a tutorial step fails during validation**, set `result: fail` and note the issue.
3. **Never fabricate validation dates.** Only stamp a tutorial after actually executing all steps.
4. **After updating frontmatter**, regenerate the dashboard:
    ```bash
    python3 scripts/generate_validation_status.py
    ```
5. **Include the regenerated dashboard** (`docs/reference/validation-status.md`) in the same commit as the frontmatter change.
6. **Do not manually edit** `docs/reference/validation-status.md` — it is auto-generated.
