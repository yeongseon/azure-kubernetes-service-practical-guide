# Correlation Query Pack

Correlation queries provide cross-signal, time-aligned views that combine events, logs, and inventory to validate troubleshooting hypotheses. These queries help you see how different parts of your cluster interact during an incident.

## Queries

| Query | Focus | Tables |
| :--- | :--- | :--- |
| [Namespace Incident Timeline](namespace-incident-timeline.md) | Unified per-namespace timeline | `KubeEvents`, `ContainerLogV2`, `KubePodInventory` |
| [Pod Log/Event Correlation](pod-log-event-correlation.md) | Align events with log lines | `KubeEvents`, `ContainerLogV2` |
| [Recent Cluster Changes](recent-cluster-changes.md) | Cluster-wide change feed | `KubeEvents`, `KubePodInventory` |

## Usage Notes

Correlation represents some of the strongest evidence available during a root cause analysis. When you align multiple signals on the same timeline, patterns emerge that single-table queries often miss. Use the `bin()` function to round `TimeGenerated` values, which makes joining different tables much easier.

## See Also

- [KQL Query Packs](../index.md)
- [Troubleshooting Index](../../index.md)
- [Troubleshooting Methodology](../../methodology/index.md)

## Sources

- https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query
- https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
- https://learn.microsoft.com/en-us/kusto/query/
