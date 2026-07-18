---
content_sources:
  - type: self-generated
    justification: Compatibility bridge page that preserves existing inbound links after the AKS metrics catalog was split by topic.
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
---

# AKS Metrics Catalog

The original consolidated AKS metrics reference has been split into topic-specific pages so readers can navigate by ownership and troubleshooting intent.

## Topics

- **[Cluster Metrics](cluster-metrics.md)**: Control-plane and cluster-wide signals such as API server latency, API request volume, etcd growth, and node count.
- **[Node Metrics](node-metrics.md)**: Node CPU, memory, conditions, and allocatable-versus-usage interpretation.
- **[Pod and Container Metrics](pod-container-metrics.md)**: Restarts, pod phases, container memory, CPU usage, and throttling context.
- **[Ingress and Networking Metrics](ingress-networking-metrics.md)**: Load balancer, SNAT, and CoreDNS signals for traffic-path diagnosis.
- **[Autoscaler Metrics](autoscaler-metrics.md)**: HPA and cluster autoscaler metrics that explain replica and capacity decisions.
- **[Managed Prometheus and Grafana](managed-prometheus-grafana.md)**: Interpretation guidance for deciding when to use Prometheus-native signals versus Azure Monitor platform metrics.

## Usage Notes

- Use this page as a stable entry point if older operations or troubleshooting content still links to `aks-metrics.md`.
- For operational setup, alert wiring, and data collection decisions, start with [Monitoring and Logging](../../operations/monitoring-logging.md).
- For reusable KQL investigations, use the [KQL query packs](../../troubleshooting/kql/index.md) instead of copying ad hoc examples from reference pages.

## See Also

- [Metrics Reference](index.md)
- [Monitoring and Logging](../../operations/monitoring-logging.md)
- [Diagnostic Commands](../diagnostic-commands.md)

## Sources

- [AKS monitoring reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
