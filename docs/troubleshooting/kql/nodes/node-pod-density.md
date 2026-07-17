# Node Pod Density

Track the number of running pods per node to identify distribution imbalances or cluster saturation.

## Query Purpose

This query calculates the density of pods across your nodes. It helps you identify hotspots where a single node is heavily loaded or clusters approaching their maximum pod limit, which can lead to scheduling failures or CNI IP address exhaustion.

## Required Tables

- `KubePodInventory` - Provides the list of pods and their current status.
- `KubeNodeInventory` - Used to verify the current node list and status.

## Query

```kusto
let latestNodeInfo = KubeNodeInventory
| summarize arg_max(TimeGenerated, Status) by Computer, ClusterName;
KubePodInventory
| where TimeGenerated > ago(30m)
| summarize arg_max(TimeGenerated, PodStatus) by Name, Computer, ClusterName
| where PodStatus == "Running"
| summarize PodCount = count() by Computer, ClusterName
| join kind=inner (latestNodeInfo) on Computer, ClusterName
| project Computer, PodCount, Status, ClusterName
| order by PodCount desc
```

## Expected Interpretation

- **Normal**: Pods are relatively evenly distributed across nodes in the same pool.
- **Abnormal**: A wide discrepancy in pod counts between identical nodes or nodes reaching the maximum pod limit.
- **Reading tip**: If a node has a high pod count but the cluster has plenty of capacity elsewhere, check for affinity rules or taints that might be concentrating pods.

## Assumptions and Limits

- The query only counts pods in a Running state.
- It does not automatically fetch the `max_pods` limit, which varies by node size and CNI configuration.

## See Also

- [Nodes Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: CNI IP Exhaustion](../../playbooks/node-issues/cni-ip-exhaustion.md)

## Sources

- [Monitor AKS with Azure Monitor](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [Kusto Query Language reference](https://learn.microsoft.com/en-us/kusto/query/)
