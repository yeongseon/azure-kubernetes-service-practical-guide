# PVC Binding Latency

Use these queries when PersistentVolumeClaims stay `Pending` or take too long to bind after a rollout, restore, or scale event.

## Query Purpose

These queries estimate claim-binding latency and highlight PVCs that remain `Pending`. They are useful for separating slow provisioning from complete provisioning failure.

## Required Tables

- `KubeEvents` - Event stream for PVC scheduling, provisioning, and binding-related messages.

## Query

### 1) PVC binding latency estimate from event sequence

```kusto
let lookback = 6h;
let creationOrPending =
    KubeEvents
    | where TimeGenerated > ago(lookback)
    | where ObjectKind == "PersistentVolumeClaim"
    | where Reason in ("Provisioning", "ExternalProvisioning", "WaitForFirstConsumer") or Message has_any ("waiting for first consumer", "provision")
    | summarize FirstSeen = min(TimeGenerated) by Namespace, ClaimName = Name;
let bound =
    KubeEvents
    | where TimeGenerated > ago(lookback)
    | where ObjectKind == "PersistentVolumeClaim"
    | where Reason in ("Bound", "ProvisioningSucceeded") or Message has "bound"
    | summarize BoundAt = min(TimeGenerated) by Namespace, ClaimName = Name;
creationOrPending
| join kind=leftouter bound on Namespace, ClaimName
| extend BindingLatencyMinutes = datetime_diff("minute", BoundAt, FirstSeen)
| project Namespace, ClaimName, FirstSeen, BoundAt, BindingLatencyMinutes
| order by BindingLatencyMinutes desc nulls last
```

### 2) PVCs still stuck in `Pending`

```kusto
let lookback = 30m;
let pendingSignals =
    KubeEvents
    | where TimeGenerated > ago(lookback)
    | where ObjectKind == "PersistentVolumeClaim"
    | where Reason in ("ExternalProvisioning", "WaitForFirstConsumer", "ProvisioningFailed")
        or Message has_any ("waiting for a volume to be created", "waiting for first consumer", "provisioning failed", "failed to provision volume")
    | summarize FirstPending = min(TimeGenerated), LastPending = max(TimeGenerated), Reasons = make_set(Reason, 5), LastMessage = arg_max(TimeGenerated, Message) by Namespace, ClaimName = Name;
let successfulBindings =
    KubeEvents
    | where TimeGenerated > ago(lookback)
    | where ObjectKind == "PersistentVolumeClaim"
    | where Reason in ("Bound", "ProvisioningSucceeded") or Message has "bound"
    | summarize LastBound = max(TimeGenerated) by Namespace, ClaimName = Name;
pendingSignals
| join kind=leftouter successfulBindings on Namespace, ClaimName
| where isnull(LastBound) or LastBound < LastPending
| project Namespace, ClaimName, FirstPending, LastPending, LastBound, Reasons, LastMessage
| order by LastPending desc
```

## Expected Interpretation

- **Latency query**: short binding times are normal during steady-state deployments; long or null `BoundAt` values suggest storage-class, quota, topology, or backend provisioning problems.
- **Pending query**: claims that keep emitting provisioning or `WaitForFirstConsumer` events without a later `Bound` or `ProvisioningSucceeded` event are likely still blocked.
- **Reading tip**: if `WaitForFirstConsumer` dominates, check scheduling and zone topology together with storage capacity instead of treating the claim as an isolated storage failure.

## Assumptions and Limits

- PVC event sequences depend on event retention and collection settings; missing Normal events can understate latency precision.
- These queries infer pending PVC state from event history, so clusters that suppress the relevant PVC events can under-report stuck claims.
- Dynamic provisioning backends can emit provider-specific messages that require extra filtering in large environments.


## See Also

- [Storage Query Pack](index.md)
- [PVC Stuck Pending](../../playbooks/storage/pvc-stuck-pending.md)
- [Storage Options](../../../platform/storage-options.md)

## Sources

- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [Query container logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
