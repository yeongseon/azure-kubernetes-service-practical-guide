# Namespace Incident Timeline

Build a single time-ordered incident timeline scoped to one namespace by unioning normalized rows from events, error logs, and pod restart transitions.

## Query Purpose

This query consolidates disparate signals into a chronological list. It helps you see the exact sequence of events, such as when a pod started failing logs relative to a Kubernetes warning event. By projecting all signals into a common schema, you can track the lifecycle of an incident across different monitoring tables.

## Required Tables

- `KubeEvents`: Provides Kubernetes control plane events like OOMKills or scheduling failures.
- `ContainerLogV2`: Provides the actual application output and error messages.
- `KubePodInventory`: Tracks pod status changes and restart counts over time.

## Query

```kusto
let ns = "default";
let lookback = 2h;
union
(
    KubeEvents
    | where TimeGenerated > ago(lookback)
    | where Namespace == ns
    | project TimeGenerated, Source = "Event", Namespace, Object = Name, Detail = strcat(Reason, ": ", Message)
),
(
    ContainerLogV2
    | where TimeGenerated > ago(lookback)
    | where PodNamespace == ns
    | where LogLevel in ("error", "critical")
    | project TimeGenerated, Source = "Log", Namespace = PodNamespace, Object = PodName, Detail = LogMessage
),
(
    KubePodInventory
    | where TimeGenerated > ago(lookback)
    | where Namespace == ns
    | project TimeGenerated, Source = "PodState", Namespace, Object = Name, Detail = strcat(PodStatus, " (Restarts: ", ContainerRestartCount, ")")
)
| order by TimeGenerated asc
```

## Expected Interpretation

- **Normal**: You see a clean sequence of pod creation, successful starts, and few or no error logs.
- **Abnormal**: A Warning event appears followed immediately by a spike in error logs and an increase in the container restart count.
- **Reading tip**: Pay close attention to the `Object` column to see if multiple pods are failing at once or if the issue is isolated to a single workload.

## Assumptions and Limits

- This query assumes that the `LogLevel` field in `ContainerLogV2` is correctly populated by your logging agent.
- Large namespaces with many logs may hit query limits, so you might need to shorten the `lookback` period.

## See Also

- [Correlation Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Troubleshooting Method](../../methodology/troubleshooting-method.md)

## Sources

- https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query
- https://learn.microsoft.com/en-us/azure/azure-monitor/logs/get-started-queries
- https://learn.microsoft.com/en-us/kusto/query/
