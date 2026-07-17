# OOMKilled Events

Identify containers terminated due to out-of-memory (OOM) conditions.

## Query Purpose
This query detects OOMKilled events within the cluster, indicating that a container exceeded its defined memory limit or the node ran out of memory. Tracking these signals helps identify workloads that need resource limit adjustments or have memory leaks.

## Required Tables
- `KubeEvents` - Captures Kubernetes event signals including OOMKilling reasons.
- `KubePodInventory` - Provides controller information to map events to their parent workloads.

## Query
```kusto
KubeEvents
| where TimeGenerated > ago(24h)
| where KubeEventType == "Warning"
| where Reason == "OOMKilling" or Message contains "OOMKilled"
| extend PodName = Name
| join kind=inner (
    KubePodInventory
    | where TimeGenerated > ago(24h)
    | summarize arg_max(TimeGenerated, *) by Name
    | project PodName = Name, ControllerName, Namespace
) on PodName, Namespace
| summarize EventCount = count() by Namespace, PodName, ControllerName, Computer
| order by EventCount desc
```

## Expected Interpretation
- **Normal**: Occasional OOM events during heavy load or specific batch jobs might be expected but should be investigated.
- **Abnormal**: Frequent OOMKilled events for the same workload suggest the memory limit is too low or the application has a memory leak.
- **Reading tip**: Correlating with `ControllerName` helps identify if the issue affects a specific Deployment or StatefulSet rather than just an isolated pod.

## Assumptions and Limits
- Events are only retained for the duration of the Log Analytics workspace retention period.
- Requires Container insights to be enabled and collecting both events and inventory data.

## See Also
- [Logs & Events Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: CrashLoopBackOff](../../playbooks/pod-issues/crashloop.md)

## Sources
- [https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
- [https://learn.microsoft.com/en-us/azure/aks/monitor-aks](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
