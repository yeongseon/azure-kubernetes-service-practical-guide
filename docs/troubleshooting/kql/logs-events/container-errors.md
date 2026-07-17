# Container Errors

Search recent container stdout and stderr logs for error patterns.

## Query Purpose
This query scans the last hour of container logs across all namespaces to identify potential application failures or service crashes. It targets common error-related keywords like "error", "exception", and "fatal" within the message body to highlight pods requiring immediate attention.

## Required Tables
- `ContainerLogV2` - Provides the raw log messages and metadata from container stdout and stderr.

## Query
```kusto
// Aggregated error counts by workload
ContainerLogV2
| where TimeGenerated > ago(1h)
| where LogMessage has_any ("error", "exception", "fatal", "fail")
| summarize ErrorCount = count() by PodNamespace, PodName, ContainerName
| order by ErrorCount desc

// Detail view: Recent raw error messages
// ContainerLogV2
// | where TimeGenerated > ago(1h)
// | where LogMessage has_any ("error", "exception", "fatal", "fail")
// | project TimeGenerated, PodNamespace, PodName, ContainerName, LogLevel, LogMessage
// | order by TimeGenerated desc
// | take 100
```

## Expected Interpretation
- **Normal**: Zero or very low error counts, often representing handled exceptions or non-critical startup warnings.
- **Abnormal**: High error counts or recurring "fatal" messages usually indicate a crash loop, misconfiguration, or backend dependency failure.
- **Reading tip**: The `LogLevel` field may be empty for logs sent directly to stdout; focus on the `LogMessage` content for patterns if `LogLevel` is not populated.

## Assumptions and Limits
- Relies on string matching; log messages not containing the specific keywords will be missed.
- The `has_any` operator is case-insensitive by default in KQL.
- Large log volumes may require narrowing the search to a specific `PodNamespace`.

## See Also
- [Logs & Events Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: CrashLoopBackOff](../../playbooks/pod-issues/crashloop.md)

## Sources
- [https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-logging-v2](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-logging-v2)
- [https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
