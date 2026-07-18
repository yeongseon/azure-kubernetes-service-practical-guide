# CSI Attach and Mount Failures

Use these queries when pods stay in `ContainerCreating`, volumes fail to attach, or Azure Disk/File mounts repeatedly retry.

## Query Purpose

These queries identify failing CSI controller logs and correlate them with Kubernetes volume events so you can quickly tell whether the incident is in the storage control path or only at pod startup.

## Required Tables

- `AzureDiagnostics` - Legacy Azure diagnostics mode for CSI controller logs.
- `AKSControlPlane` - Resource-specific mode for CSI controller logs.
- `KubeEvents` - Kubernetes events emitted for attach and mount failures.

## Query

### 1) CSI controller attach/detach and mount error logs

```kusto
let lookback = 2h;
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category in ("csi-azuredisk-controller", "csi-azurefile-controller")
    | extend RawLog = tostring(pack_all())
),
(
    AKSControlPlane
    | where TimeGenerated > ago(lookback)
    | where Category in ("csi-azuredisk-controller", "csi-azurefile-controller")
    | extend RawLog = tostring(pack_all())
)
| where RawLog has_any ("AttachVolume", "DetachVolume", "FailedMount", "MountVolume", "timed out", "rpc error", "permission denied")
| extend Driver = iff(Category contains "azuredisk", "azuredisk", iff(Category contains "azurefile", "azurefile", "unknown"))
| extend FailureClass = case(
        RawLog has_any ("AttachVolume", "attach", "disk attach"), "Attach",
        RawLog has_any ("DetachVolume", "detach"), "Detach",
        RawLog has_any ("FailedMount", "MountVolume", "mount"), "Mount",
        "Other"
    )
| summarize Failures = count(), Sample = any(RawLog) by Driver, FailureClass, bin(TimeGenerated, 10m)
| order by TimeGenerated desc, Failures desc
```

### 2) Kubernetes `FailedAttachVolume` and `FailedMount` events

```kusto
let lookback = 2h;
KubeEvents
| where TimeGenerated > ago(lookback)
| where Reason in ("FailedAttachVolume", "FailedMount", "VolumeFailedDelete")
| project TimeGenerated, Namespace, PodName = Name, Reason, Message
| order by TimeGenerated desc
```

## Expected Interpretation

- **Controller log failures**: repeated `rpc error`, timeout, or permission messages usually indicate Azure-side attach APIs, driver auth, or backend share/disk problems.
- **Kubernetes volume events**: `FailedAttachVolume` points more directly to provision/attach control paths, while `FailedMount` often reflects node-side mount completion or identity/network access.
- **Reading tip**: if controller logs are quiet but `KubeEvents` are noisy, the failure may have shifted from controller attach to node mount execution.

## Assumptions and Limits

- CSI controller logs exist only after the relevant AKS diagnostic categories are enabled.
- `KubeEvents` coverage depends on the Container insights logging profile and event collection settings.
- This page emphasizes Azure Disk and Azure File. Snapshot-controller or blob-fuse cases usually need separate patterns.

## See Also

- [Storage Query Pack](index.md)
- [Volume Attach Failure](../../playbooks/storage/volume-attach-failure.md)
- [Volume Mount Failure](../../playbooks/storage/volume-mount-failure.md)

## Sources

- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [AKS monitoring data reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Query container logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
