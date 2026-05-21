---
content_sources:
  diagrams:
    - id: reference-content-validation-status
      type: pie
      source: self-generated
      justification: Diagram source status chart generated from repository frontmatter metadata.
      based_on:
        - docs/
---

# Content Source Validation Status

This page tracks Mermaid diagram source metadata declared in document frontmatter. It does not claim text-level `content_validation` coverage; that workflow is separate from this diagram/source metadata check.

## Summary

*Last updated: 2026-05-22*

| Content Type | Total | MSLearn Sourced | Self-Generated | No Source |
|---|---:|---:|---:|---:|
| Mermaid diagrams | 69 | 32 | 37 | 0 |

!!! warning "Validation Required"
    This dashboard validates diagram source metadata only. Non-tutorial text claim validation requires `content_validation` frontmatter and is not represented by the counts on this page.

    Diagram content without direct MSLearn sources must be either:
    
    1. Linked to an official MSLearn URL, or
    2. Marked as `self-generated` with clear justification

<!-- diagram-id: reference-content-validation-status -->
```mermaid
pie title Content Source Status
    "MSLearn-backed" : 32
    "Self-generated" : 37
```

## Validation Categories

### Source Types

| Type | Description | Allowed? |
|---|---|---|
| `mslearn` | Content directly from or based on Microsoft Learn | Required for platform content |
| `mslearn-adapted` | Microsoft Learn content adapted for this guide | Yes, with source URL |
| `self-generated` | Original content created for this guide | Requires justification |
| `community` | Community sources | Not for core content |
| `unknown` | Source not documented | Must be validated |

### Diagram Validation Status

| Scope | Diagrams | Source Type | MSLearn URL | Status |
|---|---:|---|---|---|
| All documentation diagrams | 69 | mixed | documented per page frontmatter | Validated by `scripts/validate_content_sources.py` |

### Out of Scope

| Scope | Status | Tracking |
|---|---|---|
| Text-level `content_validation` metadata | Not represented on this page | Track separately until non-tutorial documents carry `content_validation` frontmatter |

## How to Validate Content

### Step 1: Add Source Metadata to Frontmatter

Add `content_sources` to the document's YAML frontmatter:

```yaml
---
title: Example Page
content_sources:
  diagrams:
    - id: cluster-overview
      type: flowchart
      source: mslearn
      mslearn_url: https://learn.microsoft.com/en-us/azure/aks/
      description: "AKS architecture overview"
    - id: troubleshooting-flow
      type: flowchart
      source: self-generated
      justification: "Synthesized from multiple Microsoft Learn articles for clarity"
      based_on:
        - https://learn.microsoft.com/en-us/azure/aks/
        - https://learn.microsoft.com/en-us/azure/aks/concepts-network
---
```

### Step 2: Mark Diagram Blocks with IDs

Add an HTML comment before each mermaid block to identify it:

~~~markdown
<!-- diagram-id: example-aks-cluster -->
```mermaid
flowchart TD
    A[Client] --> B[AKS Cluster]
```
~~~

### Step 3: Run Validation Script

```bash
python3 scripts/validate_content_sources.py
```

### Step 4: Update This Page

If diagram counts or source types change, rerun the validator and update the summary table from the repository frontmatter metadata. There is no generated text-claim inventory in this repository yet.

## Validation Rules

!!! danger "Mandatory Rules"
    1. **Platform diagrams** (`docs/platform/`) MUST have MSLearn sources
    2. **Architecture diagrams** MUST reference official Microsoft documentation
    3. **Troubleshooting flowcharts** MAY be self-generated if they synthesize MSLearn content
    4. **Self-generated content** MUST have a `justification` field explaining the source basis

## Official MSLearn Architecture References

Use these official sources for diagram validation:

| Topic | MSLearn URL |
|---|---|
| AKS Overview | https://learn.microsoft.com/en-us/azure/aks/ |
| AKS Cluster Architecture | https://learn.microsoft.com/en-us/azure/aks/concepts-clusters-workloads |
| AKS Networking | https://learn.microsoft.com/en-us/azure/aks/concepts-network |
| AKS Identity and Access | https://learn.microsoft.com/en-us/azure/aks/concepts-identity |
| AKS Security | https://learn.microsoft.com/en-us/azure/aks/concepts-security |
| AKS Storage | https://learn.microsoft.com/en-us/azure/aks/concepts-storage |
| AKS Scaling | https://learn.microsoft.com/en-us/azure/aks/concepts-scale |
| AKS Monitoring | https://learn.microsoft.com/en-us/azure/aks/monitor-aks |

## See Also

- [Tutorial Validation Status](validation-status.md)
- [CLI Cheatsheet](cli-cheatsheet.md)

## Sources

- [Azure Kubernetes Service documentation](https://learn.microsoft.com/en-us/azure/aks/)
- [AKS cluster architecture](https://learn.microsoft.com/en-us/azure/aks/concepts-clusters-workloads)
