# Node Not Ready

Detect nodes that are currently in a NotReady state and correlate them with recent node events.

## Query Purpose

This query identifies nodes reporting a status other than Ready in the last few hours. It also retrieves warning events specific to those nodes to help you understand if the issue is related to the kubelet, network connectivity, or resource pressure.

## Required Tables

- `KubeNodeInventory` - Provides the latest status and heartbeat for each node.
- `KubeEvents` - Contains system events and warnings from the Kubernetes control plane.

## Query

```kusto
// Find nodes not in Ready state
KubeNodeInventory
| where TimeGenerated > ago(3h)
| summarize arg_max(TimeGenerated, Status) by Computer, ClusterName
| where Status != "Ready";

// Correlate with node warning events
KubeEvents
| where TimeGenerated > ago(3h)
| where ObjectKind == "Node" and KubeEventType == "Warning"
| summarize Count = count() by Computer, Reason, Message, ClusterName
| order by Count desc
```

## Expected Interpretation

- **Normal**: The first query returns no results, indicating all nodes are Ready.
- **Abnormal**: Nodes appearing in the first query are experiencing downtime or communication issues.
- **Reading tip**: Check the `Message` column in the events query. If you see "Kubelet stopped" or "NodeNotReady", it often points to a crash or network partition.

## Assumptions and Limits

- The query looks back 3 hours. You can adjust the `ago()` parameter for a longer history.
- Transient network blips might cause a node to briefly report NotReady.

## See Also

- [Nodes Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: Node Not Ready](../../playbooks/node-issues/node-not-ready.md)

## Sources

- [Monitor AKS with Azure Monitor](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [Kusto Query Language reference](https://learn.microsoft.com/en-us/kusto/query/)
