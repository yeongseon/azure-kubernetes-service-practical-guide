---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-overview
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "AKS exposes Api Request Duration in Seconds as the platform metric `ApiRequestDurationSeconds`, measured in seconds with `AppName`, `GpuEnabled`, `Method`, and `Route` dimensions."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
      verified: true
    - claim: "AKS exposes API Request Count as the platform metric `ApiRequestCount`, measured as a count with `AppName`, `GpuEnabled`, `Method`, and `Route` dimensions."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
      verified: true
    - claim: "AKS monitoring includes both platform metrics and Prometheus metrics as distinct telemetry types."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
    - claim: "Azure Monitor automatically collects AKS platform metrics at no cost."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
---

# Cluster Metrics

Use cluster metrics to judge whether an AKS issue is rooted in the control plane, cluster-wide capacity, or an individual workload.

## Topic Groups

### Control-plane and cluster-wide metrics

| Metric | Source | What it means | Common use | Denominator / cardinality notes |
|---|---|---|---|---|
| `apiserver_request_duration_seconds` / `ApiRequestDurationSeconds` | Managed Prometheus for Prometheus-native views; Azure Monitor platform metric for Azure Metrics charts | API server request latency. Rising values mean slower control-plane responses or overloaded clients. | Confirm whether deployments, scaling, or upgrades are slowed by API latency rather than by node or pod issues. | Split by verb or route carefully. Cardinality grows quickly when you keep `Method` and `Route` dimensions or Prometheus labels together. |
| `apiserver_request_total` / `ApiRequestCount` | Managed Prometheus for Prometheus-native views; Azure Monitor platform metric for Azure Metrics charts | Request volume against the Kubernetes API. Error-code or route spikes often explain failed automation. | Correlate deployment storms, noisy controllers, or repeated client retries with control-plane pressure. | Rates are usually more useful than raw counts. Preserve only the labels needed for verb, resource, or status-code analysis. |
| `etcd_db_total_size_in_bytes` | Managed Prometheus | Size trend for the etcd backing store. Steady growth is expected; sudden jumps can indicate heavy object churn. | Watch for abnormal control-plane growth before upgrades, mass rollouts, or runaway custom-resource usage. | Treat it as a single-cluster trend metric, not a per-workload KPI. Compare slope over time rather than single-sample values. |
| `Node Count` | Azure Monitor platform metric | Current number of nodes in the managed cluster. | Verify whether expected scale-out or scale-in actually occurred during incidents or maintenance. | Interpret together with node pool intent. A cluster-wide total can hide imbalance across pools. |

### Interpretation priorities

- Start with API latency and request volume when `kubectl`, controllers, or upgrade workflows feel slow.
- Use `Node Count` to distinguish “cluster did not add capacity” from “cluster added nodes but pods still failed.”
- Treat `etcd_db_total_size_in_bytes` as an early-warning trend signal, not an alert threshold by itself.

## Usage Notes

- Prefer Azure Monitor platform metrics when you want fast, low-friction cluster-wide alerting and long-lived Azure-native dashboards.
- Prefer Managed Prometheus when you need Prometheus labels, rate functions, or Grafana panels that correlate control-plane signals with workload metrics.
- For incident triage, correlate cluster metrics with node and autoscaler metrics before assuming the control plane is the only problem.

## See Also

- [Node Metrics](node-metrics.md)
- [Autoscaler Metrics](autoscaler-metrics.md)
- [Upgrade Failure](../../troubleshooting/playbooks/operations/upgrade-failure.md)
- [KQL Query Packs](../../troubleshooting/kql/index.md)
- [Monitoring and Logging](../../operations/monitoring-logging.md)
- [Diagnostic Commands](../diagnostic-commands.md)

## Sources

- [AKS monitoring reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [Azure Monitor managed service for Prometheus overview](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-overview)
