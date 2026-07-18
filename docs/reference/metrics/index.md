---
content_sources:
  - type: self-generated
    justification: Hub page for the metrics reference subsection.
---

# Metrics Reference

This section provides a reference map for AKS metrics by ownership area so you can move quickly from a symptom to the right signal family.

## Topics

- **[Cluster Metrics](cluster-metrics.md)**: Control-plane and cluster-wide signals such as API server latency, request volume, etcd growth, and node count.
- **[Node Metrics](node-metrics.md)**: Node CPU, memory, conditions, and allocatable-capacity interpretation.
- **[Pod and Container Metrics](pod-container-metrics.md)**: Pod phases, restarts, container memory, CPU usage, and throttling context.
- **[Ingress and Networking Metrics](ingress-networking-metrics.md)**: Load balancer, SNAT, and CoreDNS signals for traffic-path diagnosis.
- **[Autoscaler Metrics](autoscaler-metrics.md)**: HPA and cluster autoscaler metrics that explain replica and capacity behavior.
- **[Managed Prometheus and Grafana](managed-prometheus-grafana.md)**: When to prefer Prometheus-native signals versus Azure Monitor platform metrics and Container Insights.
- **[AKS Metrics Catalog](aks-metrics.md)**: Short compatibility bridge page for older inbound links.

## Scope and Intent

Effective observability requires understanding which metrics belong to the cluster, node, workload, networking, or autoscaling layer. This section focuses on what the signals mean and where they come from. For setup, investigation, and reusable queries, use the linked operational guides and KQL packs.

- **[Monitoring and Logging](../../operations/monitoring-logging.md)**: Operational procedures for enabling and validating AKS monitoring pipelines.
- **[Troubleshooting](../../troubleshooting/index.md)**: Symptom-driven diagnosis guidance that applies these metrics in playbooks.

## See Also

- [Diagnostic Commands](../diagnostic-commands.md)
- [Evidence Map](../../troubleshooting/evidence-map.md)
- [KQL Query Packs](../../troubleshooting/kql/index.md)

## Sources

- [Monitor AKS with Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- [Azure Monitor managed service for Prometheus overview](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-overview)
- [AKS monitoring reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
