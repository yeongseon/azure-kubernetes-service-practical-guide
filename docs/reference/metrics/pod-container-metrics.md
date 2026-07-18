---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-metric-alerts
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-metric-alerts
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "AKS exposes `kube_pod_status_phase` as a count metric with `phase`, `namespace`, and `pod` dimensions."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
      verified: true
    - claim: "Container insights collects stdout and stderr logs and Kubernetes events from each node in an AKS cluster."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
    - claim: "AKS monitoring spans multiple telemetry types, including platform metrics, Prometheus metrics, activity logs, resource logs, and Container insights."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
    - claim: "Azure Monitor maps the legacy Container insights custom metric `memoryWorkingSetBytes` to the Prometheus metric `container_memory_working_set_bytes{cluster=\"$cluster\"}`."
      source: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-metric-alerts
      verified: true
---

# Pod and Container Metrics

Pod and container metrics answer whether a failure belongs to the workload itself, the scheduler, or the node beneath it.

## Topic Groups

### Workload-state and resource metrics

| Metric | Source | What it means | Common use | Denominator / cardinality notes |
|---|---|---|---|---|
| `kube_pod_container_status_restarts_total` | Managed Prometheus | Restart counter for containers in a pod. Rapid increases usually mean a crash loop, probe failure, or repeated OOM exit. | Detect unstable workloads and confirm whether restarts are still increasing after a rollout or fix. | Use change over time, not only the absolute value. Long-lived pods naturally accumulate restarts. |
| `kube_pod_status_phase` | Azure Monitor platform metric or Managed Prometheus view | Count of pods by lifecycle phase such as `Pending`, `Running`, `Succeeded`, or `Failed`. | Separate scheduling issues from runtime issues before reading logs. | `phase`, `namespace`, and `pod` dimensions can explode quickly; alert on filtered phase subsets such as `Pending` or `Failed`. |
| `container_memory_working_set_bytes` | Managed Prometheus and Azure Monitor metric views | Memory actively used by the container working set. | Compare usage against memory limits and explain OOM-related instability. | The useful denominator is the container limit or request, not node memory. |
| `container_cpu_usage_seconds_total` | Managed Prometheus | Cumulative CPU consumed by the container. | Convert to a rate to find sustained CPU usage and compare it with CPU requests or limits. | Always apply a rate window. Raw cumulative values are not interpretable on their own. |
| CPU throttling signals | Managed Prometheus | Indicates that CPU limits are preventing a container from using requested runtime, even when nodes have spare CPU. | Distinguish application slowness caused by limits from cluster-wide CPU exhaustion. | Interpret together with usage rate and configured CPU limits; throttling without saturation often means a limit is too tight. |

### Interpretation priorities

- Restarts tell you that something is unhealthy; logs and events explain why.
- `Pending` pods point toward scheduling or capacity, while `Failed` and repeated restarts point toward runtime or configuration faults.
- Working-set memory is usually a better operational signal than total memory because it tracks actively used memory.

## Usage Notes

- Use pod metrics first, then pivot to the matching KQL packs for logs, events, and OOM evidence.
- Container CPU usage should be charted as a rate in Prometheus-style tools; cumulative counters are not human-friendly by themselves.
- Throttling interpretation is only meaningful when CPU limits are configured.

## See Also

- [Node Metrics](node-metrics.md)
- [Pod CrashLoopBackOff](../../troubleshooting/playbooks/pod-crashloopbackoff.md)
- [Pending Pods](../../troubleshooting/playbooks/pod-issues/pending-pods.md)
- [CrashLoopBackOff KQL](../../troubleshooting/kql/workloads/crashloopbackoff.md)
- [Pending Pods KQL](../../troubleshooting/kql/workloads/pending-pods.md)
- [Pod Restarts KQL](../../troubleshooting/kql/workloads/pod-restarts.md)
- [OOMKilled Events KQL](../../troubleshooting/kql/logs-events/oomkilled-events.md)

## Sources

- [AKS monitoring reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [Monitor AKS with Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- [Metric alerts for Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-metric-alerts)
