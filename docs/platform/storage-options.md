---
hide:
  - toc
content_sources:
  diagrams:
  - id: platform-storage-options
    type: flowchart
    source: mslearn-adapted
    mslearn_url: https://learn.microsoft.com/en-us/azure/aks/concepts-storage
    based_on:
    - https://learn.microsoft.com/en-us/azure/aks/concepts-storage
    - https://learn.microsoft.com/en-us/azure/aks/azure-disk-csi
    - https://learn.microsoft.com/en-us/azure/aks/azure-files-csi
---




# Storage Options

AKS supports both ephemeral and persistent storage. Match the storage pattern to workload behavior instead of assuming all containers should be stateless or all data should live on Azure Disk.

## Main Content
<!-- diagram-id: platform-storage-options -->

<!-- diagram-id: platform-storage-options -->
```mermaid
flowchart TD
    A[Pod] --> B[emptyDir]
    A --> C[PersistentVolumeClaim]
    C --> D[Azure Disk CSI]
    C --> E[Azure Files CSI]
    A --> F[Secrets Store CSI]
```


### Storage patterns

| Option | Best For | Notes |
|---|---|---|
| `emptyDir` | Scratch space, caches, temporary processing | Lost when pod is rescheduled |
| Azure Disk CSI | Single-writer durable state | Strong fit for databases requiring block storage |
| Azure Files CSI | Shared file access across pods | Easier RWX semantics, different performance model |
| Secrets Store CSI | Mounted external secrets and certs | Not a replacement for general data storage |

### Example inspection commands

```bash
kubectl get pvc -A
kubectl get pv
kubectl describe pvc <pvc-name> -n <namespace>
kubectl get storageclass
```

### Design cautions

- Stateful workloads still need backup and restore design.
- Understand zone behavior for managed disks.
- Do not use persistent volumes as a substitute for object storage or external databases without clear reason.

## See Also

- [Identity and Secrets](identity-and-secrets.md)
- [Best Practices: Reliability](../best-practices/reliability.md)
- [Pending Pods](../troubleshooting/playbooks/pod-issues/pending-pods.md)

## Sources

- [AKS storage concepts](https://learn.microsoft.com/azure/aks/concepts-storage)
- [Azure Disk CSI driver on AKS](https://learn.microsoft.com/azure/aks/azure-disk-csi)
- [Azure Files CSI driver on AKS](https://learn.microsoft.com/azure/aks/azure-files-csi)
