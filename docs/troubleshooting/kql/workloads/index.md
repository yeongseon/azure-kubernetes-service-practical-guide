# Workloads Query Pack

This query pack provides tools to investigate pod-level failures using Container insights inventory, events, and logs. These queries help identify unhealthy workloads and correlate failures with cluster events.

## Queries

| Query | Focus | Tables |
| :--- | :--- | :--- |
| [Pod Restarts](pod-restarts.md) | Elevated container restart counts | `KubePodInventory` |
| [CrashLoopBackOff](crashloopbackoff.md) | Crash loop correlation with events/logs | `KubePodInventory`, `KubeEvents`, `ContainerLogV2` |
| [Pending Pods](pending-pods.md) | Scheduling failures | `KubePodInventory`, `KubeEvents` |

## Usage Notes

*   Time range: Most queries use a default lookback window of 1 to 6 hours. Adjust `ago()` values based on your incident timeline.
*   Filtering: Use `where Namespace == "your-namespace"` to narrow results in large clusters.
*   Aggregation: Queries use `summarize` to group data by controller and pod name for easier analysis.

## See Also

*   [KQL Query Packs](../index.md)
*   [Troubleshooting Overview](../../index.md)
*   [Pod Issues Playbooks](../../playbooks/index.md)

## Sources

*   [Container insights log queries](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
*   [Monitor AKS with Azure Monitor](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
*   [Kusto Query Language overview](https://learn.microsoft.com/en-us/kusto/query/)
