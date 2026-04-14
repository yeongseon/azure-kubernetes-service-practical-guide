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
│   ├── reference/              # CLI cheatsheet, glossary, limits
│   ├── start-here/             # Entry points
│   ├── stylesheets/            # Custom CSS
│   └── troubleshooting/        # Diagnosis and resolution
└── mkdocs.yml                  # MkDocs Material configuration
```

## Content Categories

The documentation is organized by intent and lifecycle stage:

| Section | Purpose |
|---|---|
| **Start Here** | Entry points, learning paths, repository map |
| **Platform** | AKS architecture, networking, node pools — WHAT and HOW it works |
| **Best Practices** | Production patterns — HOW to use the platform well |
| **Operations** | Day-2 execution — HOW to run in production |
| **Troubleshooting** | Diagnosis and resolution — hypothesis-driven |
| **Reference** | Quick lookup — CLI cheatsheet, glossary, limits |

## Documentation Conventions

### File Naming

- Tutorial: `XX-topic-name.md` (numbered for sequence)
- All others: `topic-name.md` (kebab-case)
- Index files: `index.md` in each directory

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

### PII Removal (Quality Gate)

**CRITICAL**: All CLI output examples MUST have PII removed.

**Must mask (real Azure identifiers):**

- Subscription IDs: `<subscription-id>`
- Tenant IDs: `<tenant-id>`
- Object IDs: `<object-id>`
- Resource IDs containing real subscription/tenant
- Emails: Remove or mask as `user@example.com`
- Secrets/Tokens: NEVER include

**OK to keep (synthetic example values):**

- Demo correlation IDs: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`
- Example request IDs in logs
- Placeholder domains: `example.com`, `contoso.com`
- Sample resource names used consistently in docs

The goal is to prevent leaking **real Azure account information**, not to mask obviously-fake example values that aid readability.

### Admonition Indentation Rule

For MkDocs admonitions (`!!!` / `???`), every line in the body must be indented by **4 spaces**.

```markdown
!!! warning "Important"
    This line is correctly indented.

    - List item also inside
```

### Mermaid Diagrams

All architectural diagrams use Mermaid. Every documentation page should include at least one diagram.

### Nested List Indentation

All nested list items MUST use **4-space indent** (Python-Markdown standard).

```markdown
# CORRECT (4-space)
1. **Item**
    - Sub item
    - Another sub item
        - Third level

# WRONG (2 or 3 spaces)
1. **Item**
  - Sub item          ← 2 spaces ❌
   - Sub item         ← 3 spaces ❌
```

### Tail Section Naming

Every document ends with these tail sections (in this order):

| Section | Purpose | Content |
|---|---|---|
| `## See Also` | Internal cross-links within this repository | Links to other pages in this guide |
| `## Sources` | External authoritative references | Links to Microsoft Learn (primary) |

### Canonical Document Templates

Every document follows one of 7 templates based on its section. Do not invent new structures.

#### Platform docs

```text
# Title
Brief introduction (1-2 sentences)
## Main Content
### Subsections
## See Also
## Sources
```

#### Best Practices docs

```text
# Title
Brief introduction
## Why This Matters
## Recommended Practices
## Common Mistakes / Anti-Patterns
## Validation Checklist
## See Also
## Sources
```

#### Operations docs

```text
# Title
Brief introduction
## Prerequisites
## When to Use
## Procedure
## Verification
## Rollback / Troubleshooting
## See Also
## Sources
```

#### Tutorial docs

```text
# Title
Brief introduction
## Prerequisites
## What You'll Build
## Steps
## Verification
## Next Steps / Clean Up (optional)
## See Also
## Sources (optional)
```

#### Troubleshooting docs

```text
# Title
## Symptom
## Possible Causes
## Diagnosis Steps
## Resolution
## Prevention
## See Also
## Sources
```

#### Lab Guides

```text
# Title
Brief introduction
## Lab Metadata (table: difficulty, duration, tier, etc.)
## 1) Background
## 2) Hypothesis
## 3) Runbook
## 4) Experiment Log
## Expected Evidence
## Clean Up
## Related Playbook
## See Also
## Sources
```

#### Reference docs

```text
# Title
Brief introduction
## Topic/Command Groups
## Usage Notes
## See Also
## Sources
```

## Content Source Requirements

### MSLearn-First Policy

All documentation content must be traceable to official Microsoft Learn documentation.

- Platform content must have direct Microsoft Learn source URLs.
- Architecture diagrams must reference official Microsoft documentation.
- Self-generated content must include justification explaining the source basis.

### Source Types

| Type | Description | Allowed? |
|---|---|---|
| `mslearn` | Content directly from or based on Microsoft Learn | Required for platform content |
| `mslearn-adapted` | Microsoft Learn content adapted for this guide | Yes, with source URL |
| `self-generated` | Original content created for this guide | Requires justification |
| `community` | Community sources | Not for core content |
| `unknown` | Source not documented | Must be validated |

### Diagram Source Documentation

Every Mermaid diagram must have source metadata in frontmatter.

```yaml
content_sources:
  diagrams:
    - id: cluster-overview
      type: flowchart
      source: mslearn
      mslearn_url: https://learn.microsoft.com/en-us/azure/aks/
    - id: troubleshooting-flow
      type: flowchart
      source: self-generated
      justification: "Synthesized from multiple Microsoft Learn articles for clarity"
      based_on:
        - https://learn.microsoft.com/en-us/azure/aks/
        - https://learn.microsoft.com/en-us/azure/aks/concepts-network
```

### Content Validation Tracking

- See [Content Validation Status](docs/reference/content-validation-status.md) for current status.
- See [Tutorial Validation Status](docs/reference/validation-status.md) for tutorial testing.

### Text Content Validation

Every non-tutorial document should include a `content_validation` block in frontmatter to track the verification status of its core claims.

```yaml
---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/azure/aks/...
content_validation:
  status: verified  # verified | pending_review | unverified
  last_reviewed: 2026-04-12
  reviewer: agent  # agent | human
  core_claims:
    - claim: "{example claim}"
      source: https://learn.microsoft.com/azure/aks/...
      verified: true
---
```

#### Validation Status Values

| Status | Description |
|--------|-------------|
| `verified` | All core claims have been traced to Microsoft Learn sources |
| `pending_review` | Document exists but claims need source verification |
| `unverified` | New document, no validation performed |

#### Agent Rules for Content Validation

1. When creating or modifying Platform, Best Practices, or Operations documents, add `content_validation` frontmatter.
2. List 2-5 core claims that are factual assertions (not opinions or procedures).
3. Each claim must have a Microsoft Learn source URL.
4. Set `status: verified` only when ALL core claims have verified sources.
5. Run `python3 scripts/generate_content_validation_status.py` after updates.

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

## Build & Preview

```bash
# Install MkDocs dependencies
pip install mkdocs-material mkdocs-minify-plugin

# Build documentation (strict mode catches broken links)
mkdocs build --strict

# Local preview
mkdocs serve
```

## Git Commit Style

```text
type: short description
```

Allowed types: `feat`, `fix`, `docs`, `chore`, `refactor`

## Related Projects

| Repository | Description |
|---|---|
| [azure-virtual-machine-practical-guide](https://github.com/yeongseon/azure-virtual-machine-practical-guide) | Azure Virtual Machines practical guide |
| [azure-networking-practical-guide](https://github.com/yeongseon/azure-networking-practical-guide) | Azure Networking practical guide |
| [azure-storage-practical-guide](https://github.com/yeongseon/azure-storage-practical-guide) | Azure Storage practical guide |
| [azure-app-service-practical-guide](https://github.com/yeongseon/azure-app-service-practical-guide) | Azure App Service practical guide |
| [azure-functions-practical-guide](https://github.com/yeongseon/azure-functions-practical-guide) | Azure Functions practical guide |
| [azure-container-apps-practical-guide](https://github.com/yeongseon/azure-container-apps-practical-guide) | Azure Container Apps practical guide |
| [azure-communication-services-practical-guide](https://github.com/yeongseon/azure-communication-services-practical-guide) | Azure Communication Services practical guide |
| [azure-architecture-practical-guide](https://github.com/yeongseon/azure-architecture-practical-guide) | Azure Architecture practical guide |
| [azure-monitoring-practical-guide](https://github.com/yeongseon/azure-monitoring-practical-guide) | Azure Monitoring practical guide |
