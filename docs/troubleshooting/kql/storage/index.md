# Storage Query Pack

This query pack focuses on persistent-volume operations that often fail outside normal pod-only troubleshooting. Use it when attach, mount, or PVC-binding symptoms suggest CSI-controller or storage-control issues.

## Queries

| Query | Focus | Tables |
| :--- | :--- | :--- |
| [CSI Attach and Mount Failures](csi-attach-mount-failures.md) | Azure Disk/File attach, detach, and mount failures | `AzureDiagnostics`, `AKSControlPlane`, `KubeEvents` |
| [PVC Binding Latency](pvc-binding-latency.md) | Slow claims and stuck `Pending` PVCs | `KubeEvents` |

## Usage Notes

*   CSI-controller log queries need AKS diagnostic settings for `csi-azuredisk-controller` and `csi-azurefile-controller`.
*   PVC queries rely on Kubernetes events. If Normal events are not collected, latency estimates depend more heavily on Warning events.
*   Storage incidents often need both control-plane logs and workload evidence, so pivot to the storage playbooks after identifying the failing volume or claim.

## See Also

*   [KQL Query Packs](../index.md)
*   [StatefulSet Day-2 Operations](../../../operations/statefulset-day-2-operations.md)
*   [Volume Attach Failure](../../playbooks/storage/volume-attach-failure.md)

## Sources

*   [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
*   [AKS monitoring data reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
*   [Query container logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
