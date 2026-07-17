# Pod Restarts

Identify pods experiencing high restart counts within a specific time window.

## Query Purpose
This query finds pods with elevated restart counts across namespaces, controllers, and containers. It reveals which workloads are unstable and helps prioritize troubleshooting for frequently crashing components.

## Required Tables
- `KubePodInventory` - Provides pod status and container restart counts.

## Query
`ContainerRestartCount` is cumulative since the container started, so counting restarts that actually happened inside the window requires the delta between the maximum and minimum sampled values, not the raw maximum.

```kusto
KubePodInventory
| where TimeGenerated > ago(6h)
| summarize RestartsInWindow = max(ContainerRestartCount) - min(ContainerRestartCount),
            CumulativeRestarts = max(ContainerRestartCount)
    by Namespace, ControllerName, Name, ContainerName
| where RestartsInWindow > 0
| order by RestartsInWindow desc
| take 50
```

## Expected Interpretation
- **Normal**: `RestartsInWindow` of 0 is typical for stable workloads. New deployments or planned rollouts may show 1.
- **Abnormal**: Single or double digit `RestartsInWindow` values indicate instability or liveness probe failures during the last 6 hours.
- **Reading tip**: `CumulativeRestarts` shows lifetime restarts; a high cumulative value with a low `RestartsInWindow` means the instability was earlier, not now. Use `ControllerName` to see if the issue affects a specific Deployment or StatefulSet.

## Assumptions and Limits
- Only pods monitored by Container insights are included.
- `ContainerRestartCount` is an absolute value since the container started; `RestartsInWindow` derives the in-window count from the min/max delta across sampled snapshots.
- If a container is deleted and recreated within the window, its counter resets, which can understate `RestartsInWindow`.

## See Also
- [Workloads Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: CrashLoopBackOff](../../playbooks/pod-issues/crashloop.md)

## Sources
- [Monitor AKS with Azure Monitor](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [Container insights log queries](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
