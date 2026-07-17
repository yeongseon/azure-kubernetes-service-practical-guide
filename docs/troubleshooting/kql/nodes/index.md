# Nodes Query Pack

This query pack helps you monitor and troubleshoot Azure Kubernetes Service nodes. It focuses on node readiness, resource pressure, and pod distribution using Container insights data.

## Queries

| Query | Focus | Tables |
| :--- | :--- | :--- |
| [Node Not Ready](node-not-ready.md) | NotReady detection + node events | `KubeNodeInventory`, `KubeEvents` |
| [Node CPU/Memory Pressure](node-cpu-memory-pressure.md) | Resource saturation per node | `Perf` |
| [Node Pod Density](node-pod-density.md) | Pod distribution / saturation | `KubePodInventory`, `KubeNodeInventory` |

## Usage Notes

These queries are designed for use in the Azure Monitor Logs (Log Analytics) blade. Ensure your AKS cluster has Container insights enabled to populate the required tables. When running these queries, you can filter by cluster name if your workspace collects data from multiple clusters.

## See Also

- [KQL Query Packs](../index.md)
- [Troubleshooting Index](../../index.md)
- [Node Playbooks](../../playbooks/index.md)

## Sources

- [Container insights log queries](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
- [Monitor AKS with Azure Monitor](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
