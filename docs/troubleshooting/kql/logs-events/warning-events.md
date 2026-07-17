# Warning Events

Summarize Kubernetes warning events for a cluster-wide triage overview.

## Query Purpose
This query provides a high-level summary of all Warning-level events in the last two hours. By aggregating by reason and object type, it reveals the most dominant issues currently impacting the cluster, such as scheduling failures, probe timeouts, or image pull errors.

## Required Tables
- `KubeEvents` - Stores all Kubernetes events including normal and warning types.

## Query
```kusto
KubeEvents
| where TimeGenerated > ago(2h)
| where KubeEventType == "Warning"
| summarize Count = sum(Count) by Reason, Namespace, ObjectKind
| order by Count desc
```

## Expected Interpretation
- **Normal**: A small number of warnings like `Unhealthy` (during startup) or `FailedScheduling` (during scaling) are common.
- **Abnormal**: High counts of `BackOff`, `FailedMount`, or `FailedScheduling` indicate systemic issues with nodes, storage, or resource availability.
- **Reading tip**: Focus on the `Reason` column to quickly identify common patterns like `FailedScheduling` (insufficient resources) or `Unhealthy` (failed liveness/readiness probes).

## Assumptions and Limits
- The query uses `sum(Count)` because Kubernetes often collapses multiple identical events into a single record with a count property.
- Only captures events emitted by the Kubernetes API server and seen by the monitoring agent.

## See Also
- [Logs & Events Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: CrashLoopBackOff](../../playbooks/pod-issues/crashloop.md)

## Sources
- [https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
- [https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
