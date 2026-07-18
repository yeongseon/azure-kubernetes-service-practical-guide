---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/kubepodinventory
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/kubeevents
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/perf
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "Container insights collects performance metrics, inventory data, and health state information from Kubernetes container hosts and containers."
      source: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query
      verified: true
    - claim: "The KubeEvents table stores Kubernetes events in Azure Monitor Logs."
      source: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/kubeevents
      verified: true
    - claim: "The KubePodInventory table includes pod and container fields such as ContainerStatusReason and ServiceName."
      source: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/kubepodinventory
      verified: true
    - claim: "If performance data collection is disabled or changed from default settings, queries that use the Perf table might not return results."
      source: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query
      verified: true
---

# Evidence Packs

Use this index to standardize what you capture before remediation. Every row pairs a falsification lab with the matching playbook so operators preserve the same evidence set that supports the troubleshooting hypothesis.

## Evidence Pack Matrix

| Failure class | Preserve before remediation | CLI commands | KQL queries | Healthy-signal baseline | PII masking guidance | Lab | Playbook |
|---|---|---|---|---|---|---|---|
| Image pull failure | Pod events, image reference, namespace secrets, node egress clues | `kubectl get pods --namespace workload --output wide`<br>`kubectl describe pod <pod-name> --namespace workload`<br>`kubectl get events --namespace workload --sort-by=.lastTimestamp` | `KubeEvents | where TimeGenerated > ago(30m) | where Namespace == "workload" and Reason in ("Failed", "BackOff") | project TimeGenerated, Name, Reason, Message`<br>`KubePodInventory | where TimeGenerated > ago(30m) | where Namespace == "workload" | project TimeGenerated, Name, ContainerStatusReason, ContainerID, Image` | Fixed image reference starts pods and clears pull-backoff reason | Mask real registry names only when they reveal tenant or customer identity; never publish tokens, pull secrets, subscription IDs, tenant IDs, or email addresses | [Fault Lab 01](../../tutorials/lab-guides/fault-lab-01-image-pull-failure.md) | [Image Pull Failure](../playbooks/pod-issues/image-pull-failure.md) |
| CrashLoopBackOff | Previous container logs, exit code, restart count, probe config | `kubectl get pods --namespace workload`<br>`kubectl logs <pod-name> --namespace workload --previous`<br>`kubectl describe pod <pod-name> --namespace workload` | `KubePodInventory | where TimeGenerated > ago(30m) | where Namespace == "workload" | project TimeGenerated, Name, PodStatus, ContainerRestartCount, ContainerStatusReason`<br>`KubeEvents | where TimeGenerated > ago(30m) | where Namespace == "workload" and Reason in ("BackOff", "Killing", "Unhealthy") | project TimeGenerated, Name, Reason, Message` | Pod restart count stays flat and readiness remains true after the fix | Mask stack traces only when they expose secrets, internal hostnames, or customer data; keep exit codes and reasons intact | [Fault Lab 02](../../tutorials/lab-guides/fault-lab-02-crashloopbackoff.md) | [CrashLoop](../playbooks/pod-issues/crashloop.md) |
| Pending pod from oversized requests | Scheduler events, requested resources, node allocatable, autoscaler state | `kubectl describe pod <pod-name> --namespace workload`<br>`kubectl get nodes --output wide`<br>`kubectl describe node <node-name>` | `KubeEvents | where TimeGenerated > ago(30m) | where Namespace == "workload" and Reason == "FailedScheduling" | project TimeGenerated, Name, Message`<br>`Perf | where TimeGenerated > ago(30m) | where ObjectName == "K8SNode" and CounterName in ("cpuCapacityNanoCores", "memoryCapacityBytes") | project TimeGenerated, Computer, CounterName, CounterValue` | Scheduler places the pod without `FailedScheduling` once requests are right-sized | Mask node names if they embed customer naming conventions; keep resource values and scheduler text | [Fault Lab 03](../../tutorials/lab-guides/fault-lab-03-pending-pods-resources.md) | [Pending Pods](../playbooks/pod-issues/pending-pods.md) |
| Ingress misconfiguration | Ingress spec, service, endpoints, controller events, hostname mapping | `kubectl get ingress --namespace workload --output wide`<br>`kubectl describe ingress <ingress-name> --namespace workload`<br>`kubectl get service,endpoints --namespace workload` | `KubeEvents | where TimeGenerated > ago(30m) | where Namespace == "workload" and ObjectKind == "Ingress" | project TimeGenerated, Name, Reason, Message`<br>`KubePodInventory | where TimeGenerated > ago(30m) | where Namespace == "workload" | project TimeGenerated, Name, PodStatus, PodIP` | Pods and endpoints stay healthy while ingress routes successfully after the fix | Mask public IPs, DNS names, TLS secret names, and any hostname tied to a real environment; keep port numbers and path rules | [Fault Lab 04](../../tutorials/lab-guides/fault-lab-04-ingress-misconfiguration.md) | [Ingress Failure](../playbooks/connectivity/ingress-failure.md) |
| Node pressure and scheduling boundary | Scheduler events, node readiness, labels, taints, allocatable snapshot | `kubectl describe pod <pod-name> --namespace workload`<br>`kubectl get nodes --show-labels`<br>`kubectl describe node <node-name>` | `KubeEvents | where TimeGenerated > ago(30m) | where Namespace == "workload" and Reason == "FailedScheduling" | project TimeGenerated, Name, Message`<br>`Perf | where TimeGenerated > ago(30m) | where ObjectName == "K8SNode" and CounterName in ("memoryRssBytes", "cpuUsageNanoCores") | project TimeGenerated, Computer, CounterName, CounterValue` | Nodes remain `Ready` and the pod schedules after removing the bad placement rule | Mask VMSS instance IDs, node resource IDs, subscription IDs, and tenant-linked labels; keep taint keys and scheduler messages | [Fault Lab 05](../../tutorials/lab-guides/fault-lab-05-node-pressure-scheduling.md) | [Node Not Ready](../playbooks/node-issues/node-not-ready.md) |

## Usage Notes

- Preserve evidence **before** scaling, restarting, or reapplying manifests.
- Prefer `kubectl describe`, `kubectl get events`, and read-only KQL queries before remediation.
- If you export JSON or screenshots, sanitize subscription IDs as `<subscription-id>`, tenant IDs as `<tenant-id>`, object IDs as `<object-id>`, and emails as `user@example.com`.
- Do not attach fabricated output to the repo. Store real run artifacts in the matching `labs/<slug>/evidence/` directory only after execution.

## See Also

- [Evidence Map](../evidence-map.md)
- [Quick Diagnosis Cards](../quick-diagnosis-cards.md)
- [Playbooks Index](../playbooks/index.md)

## Sources

- [Container Insights log queries](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
- [KubePodInventory table reference](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/kubepodinventory)
- [KubeEvents table reference](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/kubeevents)
- [Perf table reference](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/perf)
