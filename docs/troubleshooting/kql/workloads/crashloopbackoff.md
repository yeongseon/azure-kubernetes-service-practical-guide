# CrashLoopBackOff

Correlate container crash loops with warning events and application logs.

## Query Purpose
This query pack links pods in a crash loop state with their associated warning events and recent log entries. It helps you determine if a crash is caused by application errors, missing dependencies, or configuration issues.

## Required Tables
- `KubePodInventory` - Identifies pods with high restart counts.
- `KubeEvents` - Captures reason codes like BackOff or Failed.
- `ContainerLogV2` - Provides the application stderr/stdout output.

## Query

### 1) Identify Crashing Pods
Find containers that actually restarted more than 5 times **within the last hour**. Because `ContainerRestartCount` is cumulative since container start, use the max/min delta over the window rather than the raw count.

```kusto
KubePodInventory
| where TimeGenerated > ago(1h)
| summarize RestartsInWindow = max(ContainerRestartCount) - min(ContainerRestartCount),
            CumulativeRestarts = max(ContainerRestartCount)
    by Namespace, Name, ContainerName
| where RestartsInWindow > 5
| order by RestartsInWindow desc
```

### 2) Check Warning Events
Find scheduling or lifecycle warnings related to these pods.

```kusto
KubeEvents
| where TimeGenerated > ago(1h)
| where Reason in ("BackOff", "Failed") and KubeEventType == "Warning"
| summarize EventCount = count() by Namespace, Name, Reason, Message
| order by EventCount desc
```

### 3) Search for Error Logs
Search recent container logs for common error patterns.

```kusto
ContainerLogV2
| where TimeGenerated > ago(30m)
| where LogMessage has "error" or LogMessage has "exception" or LogMessage has "fatal"
| project TimeGenerated, PodNamespace, PodName, ContainerName, LogMessage
| take 100
```

## Expected Interpretation
- **Normal**: Occasional restarts during rollout or node maintenance.
- **Abnormal**: Constant restarts paired with "BackOff" events and error logs indicating application crashes (e.g., Exit Code 1 or 137).
- **Reading tip**: Compare the timestamp of the "BackOff" event with the latest log entry to find the exact moment of failure.

## Assumptions and Limits
- `ContainerLogV2` must be enabled in the cluster settings.
- Logs may be missing if the container crashes before the log collector can scrape them.

## See Also
- [Workloads Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: CrashLoopBackOff](../../playbooks/pod-issues/crashloop.md)

## Sources
- [Troubleshoot pods and containers](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-troubleshoot-pods)
- [Container insights log queries](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
