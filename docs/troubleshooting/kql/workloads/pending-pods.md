# Pending Pods

Investigate pods stuck in a Pending state and identify scheduling failures.

## Query Purpose
This query identifies pods that cannot be scheduled and extracts the specific reasons provided by the Kubernetes scheduler. It highlights issues like resource exhaustion, selector mismatches, or persistent volume binding failures.

## Required Tables
- `KubePodInventory` - Identifies pods in the Pending status.
- `KubeEvents` - Provides detailed scheduling error messages.

## Query

### 1) List Pending Pods
Find all pods currently stuck in the Pending phase.

```kusto
KubePodInventory
| where TimeGenerated > ago(1h)
| where PodStatus == "Pending"
| summarize StartTime = min(PodStartTime) by Namespace, Name, ControllerName
```

### 2) Identify Scheduling Warnings
Extract warning messages from the scheduler to find out why pods are pending.

```kusto
KubeEvents
| where TimeGenerated > ago(1h)
| where Reason in ("FailedScheduling", "FailedCreate") and KubeEventType == "Warning"
| project TimeGenerated, Namespace, Name, Reason, Message
```

## Expected Interpretation
- **Normal**: Temporary pending state during cluster scaling or image pulling.
- **Abnormal**: Persistent pending state with "FailedScheduling" messages mentioning "0/N nodes are available".
- **Reading tip**: Look for messages like "Insufficient cpu", "node(s) had untolerated taint", or "pod has unbound immediate PersistentVolumeClaims".

## Assumptions and Limits
- Events are only retained for a limited time (typically 1 hour in Kubernetes, though Azure Monitor may retain them longer).
- This query does not distinguish between user-triggered pending states and system-triggered failures.

## See Also
- [Workloads Query Pack](index.md)
- [KQL Query Packs](../index.md)
- [Playbook: Pending Pods](../../playbooks/pod-issues/pending-pods.md)

## Sources
- [Troubleshoot pods and containers](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-troubleshoot-pods)
- [Monitor AKS with Azure Monitor](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
