---
content_sources:
  - type: self-generated
    justification: AKS metrics reference synthesized from Microsoft Learn and operational best practices.
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
---

# AKS Metrics Reference

Monitoring an AKS cluster requires a multi-layered approach that tracks the health of the control plane, the underlying nodes, and the running workloads.

## Where Metrics Come From

Before selecting metrics, you must understand the three primary sources of observability data in AKS.

| Source | Collection | Retention | Primary Use Case |
|---|---|---|---|
| **Platform Metrics** | Host/Platform | 93 days | Near real-time alerting on cluster-wide health and resource usage. |
| **Managed Prometheus** | Add-on (Scraping) | 18 months | High-cardinality metrics for Kubernetes-native tools and Grafana. |
| **Container Insights** | Add-on (Agent) | Variable | Deep log analysis and historical trend correlation using KQL. |

## Cluster and Control Plane Metrics

These metrics track the health of the Kubernetes API server and etcd, providing visibility into the management layer.

| Metric | Source | Indicates | Healthy vs Alert |
|---|---|---|---|
| **apiserver_request_duration_seconds** | Managed Prometheus | API server response latency. | Alert if P99 latency exceeds 1 second for standard operations. |
| **apiserver_request_total** | Managed Prometheus | Total requests by verb/resource. | Monitor for spikes in 4xx or 5xx error codes. |
| **etcd_db_total_size_in_bytes** | Managed Prometheus | Size of the etcd database. | Alert if approaching etcd storage limits (usually 2-8GB). |
| **Node Count** | Platform Metric | Total nodes in the cluster. | Alert if count deviates significantly from desired scaling state. |

## Node Metrics

Node health is critical for workload stability. Monitor these signals to detect hardware pressure or configuration issues.

| Metric | Source | Indicates | Healthy vs Alert |
|---|---|---|---|
| **node_cpu_usage_percentage** | Platform Metric | CPU utilization of the node. | Alert if sustained usage is above 80% for non-burst workloads. |
| **node_memory_working_set_percentage** | Platform Metric | Memory pressure on the node. | Alert if consistently above 85% to prevent OOM events. |
| **kube_node_status_condition** | Managed Prometheus | Current node state (Ready, DiskPressure, etc). | Alert immediately on `Ready=False` or `DiskPressure=True`. |
| **Allocatable vs Usage** | Container Insights | Capacity reserved for pods. | Monitor to ensure system overhead isn't starving workloads. |

## Pod and Workload Metrics

These metrics focus on the behavior of individual applications and their resource consumption.

| Metric | Source | Indicates | Healthy vs Alert |
|---|---|---|---|
| **kube_pod_container_status_restarts_total** | Managed Prometheus | Total container restarts. | Alert on rapid increase in restarts (CrashLoopBackOff). |
| **kube_pod_status_phase** | Managed Prometheus | Pod lifecycle stage (Pending, Failed, etc). | Alert on pods stuck in `Pending` for more than 5 minutes. |
| **container_memory_working_set_bytes** | Managed Prometheus | Actual memory used by a container. | Alert if usage approaches configured memory limits. |
| **container_cpu_usage_seconds_total** | Managed Prometheus | CPU cycles consumed. | Monitor for throttling if `cpu_limit` is set too low. |

## Networking Metrics

Networking signals help identify connectivity bottlenecks and resource exhaustion.

| Metric | Source | Indicates | Healthy vs Alert |
|---|---|---|---|
| **Active Connections** | Platform Metric | Load balancer connection count. | Monitor for unexpected spikes that might suggest a DDoS or leak. |
| **SNAT Port Usage** | Container Insights (KQL) | Outbound port consumption. | Alert if usage exceeds 80% to prevent outbound failures. |
| **dns_request_duration_seconds** | Managed Prometheus | CoreDNS resolution latency. | Alert if resolution becomes slow, impacting service discovery. |

## Autoscaling Metrics

Signals from the Horizontal Pod Autoscaler (HPA) and Cluster Autoscaler (CA).

| Metric | Source | Indicates | Healthy vs Alert |
|---|---|---|---|
| **kube_hpa_status_current_replicas** | Managed Prometheus | Current number of pod replicas. | Monitor for HPA hitting `maxReplicas` frequently. |
| **cluster_autoscaler_unschedulable_pods** | Managed Prometheus | Pods waiting for node scaling. | Alert if pods stay unschedulable due to quota or resource limits. |

## Example Queries

### Container Insights (KQL)

```kql
// Calculate memory usage percentage by pod over time
KubePodInventory
| where TimeGenerated > ago(1h)
| join kind=inner (
    Perf
    | where TimeGenerated > ago(1h)
    | where CounterName == "memoryWorkingSetBytes"
) on $left.Name == $right.InstanceName
| summarize AggregatedValue = avg(CounterValue) by Name, bin(TimeGenerated, 5m)
```

```kql
// Find pods with high restart counts in the last 24 hours
KubePodInventory
| where TimeGenerated > ago(24h)
| where ContainerRestartCount > 0
| summarize MaxRestarts = max(ContainerRestartCount) by Name, Namespace
| order by MaxRestarts desc
```

### Managed Prometheus (PromQL)

```promql
// Identify nodes with Ready=False status
kube_node_status_condition{condition="Ready", status="true"} == 0
```

```promql
// Calculate CPU usage rate for containers, excluding system namespaces
sum(rate(container_cpu_usage_seconds_total{namespace!~"kube-system"}[5m])) by (pod, container)
```

## Usage Notes

- **Metric Latency**: Platform metrics are usually faster (1-minute granularity) than log-based metrics from Container Insights.
- **Aggregation**: Use `avg` or `max` carefully; `max` is often better for detecting transient spikes that `avg` might smooth out.
- **Context**: Always correlate workload metrics with node metrics to distinguish between application bugs and infrastructure pressure.

## See Also

- [Monitoring and Logging](../../operations/monitoring-logging.md)
- [Diagnostic Commands](../diagnostic-commands.md)
- [Troubleshooting Overview](../../troubleshooting/index.md)

## Sources

- [Monitor AKS with Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- [Azure Monitor Managed Service for Prometheus](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-overview)
- [AKS monitoring reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
