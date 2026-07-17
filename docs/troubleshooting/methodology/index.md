---
content_validation:
  status: verified
  last_reviewed: "2026-07-17"
  reviewer: agent
  core_claims:
    - claim: "Container insights collects Kubernetes inventory, events, and container logs into Log Analytics tables for AKS diagnostics."
      source: "https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview"
      verified: true
    - claim: "AKS provides Diagnose and solve problems in the Azure portal to surface cluster health insights without configuration."
      source: "https://learn.microsoft.com/en-us/azure/aks/aks-diagnostics"
      verified: true
---

# Troubleshooting Methodology

Standardize how you investigate and resolve issues in your Azure Kubernetes Service clusters. This section provides the frameworks and tools needed to move from symptom to root cause through evidence-based analysis.

| Resource | Purpose |
| :--- | :--- |
| [Troubleshooting Method](troubleshooting-method.md) | Hypothesis-driven, evidence-based investigation for AKS |
| [Decision Tree](../decision-tree.md) | Route a symptom to a category |
| [Evidence Map](../evidence-map.md) | Know what evidence to gather |
| [KQL Query Packs](../kql/index.md) | Reusable Container insights queries |

## When to Use This

Use these methodology resources when:

*   A cluster or workload behaves unexpectedly but the cause isn't immediately obvious.
*   You need to gather structured evidence for a support ticket or internal incident report.
*   The team wants to reduce Mean Time to Recovery (MTTR) by following a repeatable process.
*   Standard documentation doesn't cover the specific failure pattern you're seeing.

## See Also

*   [Decision Tree](../decision-tree.md)
*   [Evidence Map](../evidence-map.md)
*   [KQL Query Packs](../kql/index.md)
*   [First 10 Minutes](../first-10-minutes/index.md)

## Sources

*   [Container insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
*   [AKS diagnostics overview](https://learn.microsoft.com/en-us/azure/aks/aks-diagnostics)
*   [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
