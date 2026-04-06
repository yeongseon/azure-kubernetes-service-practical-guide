# AGENTS.md

Guidance for AI agents working in this repository.

## Project Overview

**Azure AKS Practical Guide** — a documentation hub for deploying and operating containerized applications on Azure Kubernetes Service (AKS).

- **Live site**: <https://yeongseon.github.io/azure-aks-practical-guide/>
- **Repository**: <https://github.com/yeongseon/azure-aks-practical-guide>

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
