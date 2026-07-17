# Pod Log/Event Correlation

Correlate a pod's warning events with container log messages in nearby time bins to find the root cause of failures.

## Query Purpose

Infrastructure events and application logs often hold different pieces of the same puzzle. This query aligns warning events from the Kubernetes API with the application logs produced at that exact moment. By joining these datasets on a one-minute time window, you can identify if a specific system event triggered a cascade of errors in your code.

## Required Tables

- `KubeEvents`: Captures warnings such as failed probes, resource pressure, or scheduling issues.
- `ContainerLogV2`: Contains the stdout and stderr streams from the containerized application.

## Query

```kusto
let podName = "my-app-pod";
let lookback = 1h;
KubeEvents
| where TimeGenerated > ago(lookback)
| where Name == podName
| where KubeEventType == "Warning"
| project EventTime = bin(TimeGenerated, 1m), Reason, EventMessage = Message
| join kind=inner (
    ContainerLogV2
    | where TimeGenerated > ago(lookback)
    | where PodName == podName
    | project LogTime = bin(TimeGenerated, 1m), LogMessage, LogLevel
) on $left.EventTime == $right.LogTime
| project EventTime, Reason, EventMessage, LogLevel, LogMessage
| order by EventTime desc
```

## Expected Interpretation

- **Normal**: The query returns no results if there are no warning events or if logs look healthy during those events.
- **Abnormal**: Multiple log lines with high severity appear in the same minute as a "Unhealthy" or "FailedMount" event.
- **Reading tip**: Use the `Reason` column to categorize the type of failure, then look for corresponding exceptions in the `LogMessage` field.

## Assumptions and Limits

- The one-minute bin provides a reasonable window for correlation, but network latency or clock drift might require a wider window.
- Inner joins will exclude events that have no corresponding logs, so check both tables individually if you find nothing.

## See Also

- [Correlation Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Troubleshooting Method](../../methodology/troubleshooting-method.md)

## Sources

- https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query
- https://learn.microsoft.com/en-us/azure/aks/monitor-aks
- https://learn.microsoft.com/en-us/kusto/query/
