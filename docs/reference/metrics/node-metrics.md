---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-metric-alerts
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "AKS exposes `node_cpu_usage_percentage` as a percent-based node metric with `node` and `nodepool` dimensions."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
      verified: true
    - claim: "AKS exposes `node_memory_working_set_percentage` as a percent-based node metric with `node` and `nodepool` dimensions."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
      verified: true
    - claim: "AKS exposes `kube_node_status_condition` with `condition`, `status`, `status2`, and `node` dimensions."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
      verified: true
    - claim: "AKS exposes `kube_node_status_allocatable_cpu_cores` as a count metric for total available CPU cores in the managed cluster."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
      verified: true
---

# Node Metrics

Node metrics tell you whether a workload symptom is really a host-capacity or node-health problem.

## Topic Groups

### Capacity and condition metrics

| Metric | Source | What it means | Common use | Denominator / cardinality notes |
|---|---|---|---|---|
| `node_cpu_usage_percentage` | Azure Monitor platform metric | Aggregated CPU utilization for a node. Sustained high values signal tight headroom for scheduling and burst handling. | Detect node saturation, noisy-neighbor behavior, or insufficient pool sizing. | Split by `nodepool` first for alerting; use `node` only when you need to isolate one instance. |
| `node_memory_working_set_percentage` | Azure Monitor platform metric | Working-set memory pressure on the node. High sustained values reduce safety margin before eviction or OOM behavior. | Differentiate memory pressure from application-specific restarts. | Percent metrics are best for pool comparisons; confirm with absolute bytes before resizing nodes. |
| `kube_node_status_condition` | Azure Monitor platform metric or Managed Prometheus depending on workspace view | Node condition state such as `Ready`, `DiskPressure`, or `MemoryPressure`. | Confirm whether scheduling failures or pod evictions are caused by unhealthy nodes. | This metric is label-heavy. Filter to one condition at a time instead of charting every condition for every node. |
| Allocatable vs usage (`kube_node_status_allocatable_*` versus observed CPU/memory usage) | Azure Monitor platform metrics plus Container Insights context | Headroom available to schedulable pods after Kubernetes and system reservations. | Judge whether the pool is full because of requests, not because VM size looks large on paper. | Compare allocatable values with requests and working-set trends; raw VM size is the wrong denominator for Kubernetes scheduling. |

### Interpretation priorities

- `Ready=False` or pressure conditions usually explain node-scoped incidents faster than application logs do.
- High CPU or memory percentage without matching workload growth often points to daemonset overhead, runaway pods, or too-small nodes.
- Allocatable-versus-usage analysis matters because pod scheduling is based on allocatable capacity, not advertised VM capacity.

## Usage Notes

- Use node metrics together with the [Node Not Ready](../../troubleshooting/playbooks/node-not-ready.md) playbook when only one pool or a handful of nodes look unhealthy.
- Container Insights adds longer investigative context, but Azure Monitor node metrics are the fastest way to alert on pressure and health changes.
- For recurring pressure issues, review requests and limits before concluding that the pool always needs larger VMs.

## See Also

- [Pod and Container Metrics](pod-container-metrics.md)
- [Node Not Ready](../../troubleshooting/playbooks/node-not-ready.md)
- [Node CPU and Memory Pressure](../../troubleshooting/kql/nodes/node-cpu-memory-pressure.md)
- [Node Not Ready KQL](../../troubleshooting/kql/nodes/node-not-ready.md)
- [Monitoring and Logging](../../operations/monitoring-logging.md)

## Sources

- [AKS monitoring reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Monitor AKS with Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- [Metric alerts for Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-metric-alerts)
