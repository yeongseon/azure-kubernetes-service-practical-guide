# Recent Cluster Changes

Surface recent pod lifecycle changes and event reasons across the whole cluster as a continuous change feed.

## Query Purpose

Major incidents often start with a small configuration change or a routine deployment. This query creates a unified feed of cluster activity, including new pod starts, restarts, and significant Kubernetes events. It helps you quickly identify the "last known good" state and see what specific action preceded a performance drop or availability issue.

## Required Tables

- `KubeEvents`: Captures the intentions and actions of the Kubernetes controller manager and scheduler.
- `KubePodInventory`: Provides snapshots of pod properties, including start times and restart counts.

## Query

```kusto
let lookback = 1h;
union
(
    KubeEvents
    | where TimeGenerated > ago(lookback)
    | project TimeGenerated, Type = "Event", Namespace, Name, Detail = strcat(KubeEventType, " - ", Reason, ": ", Message)
),
(
    // New pod starts: use PodStartTime as the event timestamp so the feed is chronological
    KubePodInventory
    | where TimeGenerated > ago(lookback)
    | where PodStartTime > ago(lookback)
    | summarize arg_min(PodStartTime, *) by Namespace, Name
    | project TimeGenerated = PodStartTime, Type = "PodLifecycle", Namespace, Name, Detail = strcat("New pod started at ", PodStartTime)
),
(
    // Restarts that actually occurred within the window (cumulative counter delta)
    KubePodInventory
    | where TimeGenerated > ago(lookback)
    | summarize RestartsInWindow = max(ContainerRestartCount) - min(ContainerRestartCount),
                LastSeen = max(TimeGenerated),
                CumulativeRestarts = max(ContainerRestartCount)
        by Namespace, Name, ContainerName
    | where RestartsInWindow > 0
    | project TimeGenerated = LastSeen, Type = "PodRestart", Namespace, Name,
              Detail = strcat(ContainerName, " restarted ", RestartsInWindow, " time(s) in window (cumulative ", CumulativeRestarts, ")")
)
| order by TimeGenerated desc
```

## Expected Interpretation

- **Normal**: You see occasional Normal events and rare PodLifecycle entries during scheduled deployments.
- **Abnormal**: A sudden flood of PodRestart entries or Warning events across multiple namespaces suggests a cluster-wide issue like resource exhaustion or network failure.
- **Reading tip**: Look for the first Warning event in the list to find the likely trigger for subsequent failures.

## Assumptions and Limits

- `KubePodInventory` reports data every few minutes, so there might be a slight delay in detecting new pod starts compared to `KubeEvents`.
- The query focuses on pods, so it may miss cluster-level changes like node scale-up events unless they trigger pod movements.

## See Also

- [Correlation Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Troubleshooting Method](../../methodology/troubleshooting-method.md)

## Sources

- https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query
- https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
- https://learn.microsoft.com/en-us/kusto/query/
