# Node CPU and Memory Pressure

Analyze resource saturation across your nodes by reviewing CPU and memory usage trends.

## Query Purpose

This query helps you spot nodes that are consistently running near their resource limits. By comparing average and maximum usage over time, you can distinguish between short spikes and sustained pressure that might lead to pod evictions.

## Required Tables

- `Perf` - Provides performance counters for CPU and memory usage from the K8SNode object.

## Query

```kusto
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SNode"
| where CounterName in ("cpuUsageNanoCores", "memoryWorkingSetBytes")
| summarize AvgValue = avg(CounterValue), MaxValue = max(CounterValue) by Computer, CounterName, bin(TimeGenerated, 5m)
| order by Computer asc, TimeGenerated desc
```

## Expected Interpretation

- **Normal**: Average values stay well below the node's allocatable capacity.
- **Abnormal**: Sustained high average values or maximum values frequently hitting the node limit.
- **Reading tip**: High memory usage is often more critical than CPU spikes, as memory pressure triggers the node's out-of-memory (OOM) killer or pod evictions.

## Assumptions and Limits

- This query looks at raw usage values. To compute percentage utilization, you would need to join this data with allocatable capacity metrics or use `InsightsMetrics`.
- The sampling interval depends on your Container insights configuration.

## See Also

- [Nodes Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: Node Not Ready](../../playbooks/node-issues/node-not-ready.md)

## Sources

- [Container insights performance metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
- [Kusto Query Language reference](https://learn.microsoft.com/en-us/kusto/query/)
