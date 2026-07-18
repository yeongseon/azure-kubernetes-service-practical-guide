# Cluster Autoscaler Decisions

Use these queries when pods stay unschedulable, node pools stop growing, or scale-down behavior looks too slow or too aggressive.

## Query Purpose

These queries focus on AKS cluster-autoscaler control-plane logs. They help explain what the autoscaler decided, why it refused to act, and how long node-pool growth took after pressure started.

## Required Tables

- `AzureDiagnostics` - Legacy Azure diagnostics mode for AKS resource logs.
- `AKSControlPlane` - Resource-specific mode for AKS control-plane logs.

## Query

### 1) Scale-up and scale-down decision timeline

```kusto
let lookback = 2h;
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category == "cluster-autoscaler"
    | extend RawLog = tostring(pack_all())
),
(
    AKSControlPlane
    | where TimeGenerated > ago(lookback)
    | where Category == "cluster-autoscaler"
    | extend RawLog = tostring(pack_all())
)
| where RawLog has_any ("scale up", "scale-down", "scaled up", "scaled down", "increase size", "decrease size")
| extend Direction = case(
        RawLog has_any ("scale down", "scaled down", "decrease size"), "ScaleDown",
        RawLog has_any ("scale up", "scaled up", "increase size"), "ScaleUp",
        "Other"
    )
| extend NodePool = coalesce(
        extract(@'node group\s+([^,\]]+)', 1, RawLog),
        extract(@'agentpool[^\s,:=]*[=: ]+([^",\s]+)', 1, RawLog),
        "unknown"
    )
| summarize Events = count(), Sample = any(RawLog) by bin(TimeGenerated, 5m), Direction, NodePool
| order by TimeGenerated desc
```

### 2) "No scale up" / "no candidates" reason extraction

```kusto
let lookback = 2h;
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category == "cluster-autoscaler"
    | extend RawLog = tostring(pack_all())
),
(
    AKSControlPlane
    | where TimeGenerated > ago(lookback)
    | where Category == "cluster-autoscaler"
    | extend RawLog = tostring(pack_all())
)
| where RawLog has_any ("No scale up", "no scale-up", "No candidates", "No expansion options", "max node group size reached", "upcoming 0 nodes")
| extend Reason = case(
        RawLog has "max node group size reached", "PoolMaxReached",
        RawLog has_any ("No candidates", "No expansion options"), "NoCandidatePool",
        RawLog has_any ("No scale up", "no scale-up"), "NoScaleUpDecision",
        RawLog has "upcoming 0 nodes", "ProvisioningLagOrNoAction",
        "Other"
    )
| summarize Hits = count(), Sample = any(RawLog) by Reason
| order by Hits desc
```

### 3) Node-pool growth lag after first unschedulable signal

```kusto
let lookback = 2h;
let autoscaler = union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category == "cluster-autoscaler"
    | extend RawLog = tostring(pack_all())
),
(
    AKSControlPlane
    | where TimeGenerated > ago(lookback)
    | where Category == "cluster-autoscaler"
    | extend RawLog = tostring(pack_all())
);
let FirstPressure = toscalar(autoscaler
| where RawLog has_any ("unschedulable", "pod didn't trigger scale-up", "cannot schedule")
| summarize min(TimeGenerated));
let FirstScaleUp = toscalar(autoscaler
| where RawLog has_any ("scale up", "scaled up", "increase size")
| summarize min(TimeGenerated));
print FirstPressure = FirstPressure, FirstScaleUp = FirstScaleUp
| where isnotnull(FirstPressure) and isnotnull(FirstScaleUp)
| extend GrowthLagMinutes = datetime_diff("minute", FirstScaleUp, FirstPressure)
| project FirstPressure, FirstScaleUp, GrowthLagMinutes
```

## Expected Interpretation

- **Decision timeline**: repeated scale-up events without recovery suggest quota, subnet, or node-boot bottlenecks outside the autoscaler itself.
- **Reason extraction**: `PoolMaxReached` or `NoCandidatePool` usually means the autoscaler is behaving correctly but boundaries or pool design are wrong.
- **Growth lag**: long delays between first unschedulable evidence and first scale-up action point to log gaps, autoscaler blockage, or infrastructure bottlenecks.

## Assumptions and Limits

- These queries require `cluster-autoscaler` in the AKS diagnostic setting.
- Message text varies between autoscaler versions, so reason extraction is pattern-based instead of schema-based.
- Growth-lag output is most useful when an incident has a single dominant burst of unschedulable pods.

## See Also

- [Control Plane Query Pack](index.md)
- [Scaling](../../first-10-minutes/scaling.md)
- [Scaling Operations](../../../operations/scaling-operations.md)

## Sources

- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [AKS monitoring data reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Query container logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
