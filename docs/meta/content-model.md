# Content Model and Taxonomy

The Azure Kubernetes Service Practical Guide follows a structured content model designed to support the reader through every stage of the service lifecycle, from initial exploration to production operations and troubleshooting.

## Core and Extension Sections

The repository is organized into core sections that align with the Azure Practical Guide series contract, supplemented by extension sections specific to AKS workloads.

### Core Sections

| Section | Lifecycle Stage | Intent |
|---|---|---|
| **Start Here** | Discovery | Entry points, learning paths, and service positioning. |
| **Platform** | Architecture | How AKS works, core concepts, and architecture deep dives. |
| **Best Practices** | Design | Production patterns, security baseline, and reliability guidance. |
| **Operations** | Day-2 | Procedural execution for managing and maintaining clusters. |
| **Troubleshooting** | Recovery | Hypothesis-driven diagnosis and resolution playbooks. |
| **Reference** | Quick Lookup | CLI cheatsheets, limits, and glossary. |

### Approved Extension Sections

- **Tutorials**: Hands-on learning sequences and tool-specific walkthroughs.
- **Lab Guides**: Reproducible experiments and validation exercises.
- **Language Guides**: Runtime-specific implementation tutorials (e.g., Python on AKS).
- **Visualization**: Architecture maps, identity flows, and visual learning surfaces.
- **Meta**: Repository taxonomy, content model, and maintainer guidance.

## Document Templates

All documents must follow one of the seven canonical templates defined in `AGENTS.md`. This ensures a consistent reading experience across the guide.

| Template | Primary Use Case |
|---|---|
| **Platform** | Conceptual and architecture documentation. |
| **Best Practices** | Recommended patterns, anti-patterns, and checklists. |
| **Operations** | Procedural "How-To" guides with verification and rollback. |
| **Tutorial** | Sequential, hands-on learning paths for specific tasks. |
| **Troubleshooting** | Symptom-based diagnosis, causes, and resolution steps. |
| **Lab Guide** | Hypothesis-driven experiments with experiment logs. |
| **Reference** | Lists, tables, CLI commands, and quick-lookup data. |

## Validation Requirements

Content validation ensures the accuracy of factual claims and the reproducibility of hands-on content.

- **Factual Claims**: Documents in `platform/`, `best-practices/`, and `operations/` require `content_validation` frontmatter with direct links to Microsoft Learn sources.
- **Tutorial Reproducibility**: Tutorial documents require `validation` frontmatter recording the last successful end-to-end execution date and CLI version.
- **Out-of-Scope**: Index pages, `start-here/`, `reference/`, and `meta/` sections are generally excluded from formal claim validation.

## Issue-to-Content Mapping

When processing the repository backlog or new GitHub issues, use this mapping to determine the appropriate destination for new content:

| Issue Type / Gap | Documentation Path |
|---|---|
| New AKS feature or concept | `docs/platform/` |
| Security, reliability, or cost advice | `docs/best-practices/` |
| Day-2 procedure (e.g., upgrade, rotate) | `docs/operations/` |
| Bug reproduction or failure playbook | `docs/troubleshooting/` |
| Hands-on lab or walkthrough | `docs/tutorials/` |
| CLI command or glossary term | `docs/reference/` |

## Terminology and Conventions

Consistent naming and command styles ensure clarity across the guide.

### Variable Naming

| Variable | Description | Example |
|----------|-------------|---------|
| `$RG` | Resource group name | `rg-aks-demo` |
| `$CLUSTER_NAME` | AKS cluster name | `aks-demo` |
| `$LOCATION` | Azure region | `koreacentral` |

### CLI Standards

- **Long Flags**: Always use long flags (e.g., `--resource-group`) instead of short flags (`-g`).
- **PII Masking**: Mask all real subscription IDs, tenant IDs, and secrets in examples.

## See Also

- [Meta Index](index.md)
- [Repository Map](../start-here/repository-map.md)
- [Glossary](../reference/glossary.md)

## Sources

- [AGENTS.md](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/blob/main/AGENTS.md)
- [Azure Kubernetes Service Documentation](https://learn.microsoft.com/en-us/azure/aks/)
