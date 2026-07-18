---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-overview
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "AKS monitoring spans multiple telemetry types, including platform metrics, Prometheus metrics, activity logs, resource logs, and Container insights."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
    - claim: "Azure Monitor automatically collects AKS platform metrics at no cost."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
    - claim: "Container insights collects stdout and stderr logs and Kubernetes events from each node in an AKS cluster."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
---

# Managed Prometheus and Grafana

Use this page to decide which AKS signals belong in Managed Prometheus and Grafana versus Azure Monitor platform metrics and Container Insights.

## Topic Groups

### Where each signal type fits best

| Signal type | Best source | Use it when | Caveats |
|---|---|---|---|
| Cluster-wide health counts and percentages | Azure Monitor platform metrics | You want Azure-native metrics, fast alerting, and simple dimensions for node, pool, or cluster views. | Platform metrics are intentionally lower-cardinality than Prometheus. They are excellent for alerting but less expressive for label-rich Kubernetes analysis. |
| Kubernetes and container counters, histograms, and per-object series | Managed Prometheus and Grafana | You need Prometheus rates, histograms, or label-aware dashboards for pods, containers, APIs, or CoreDNS. | Cardinality grows quickly when you keep namespace, pod, container, route, or status labels together. Keep dashboards and recording rules selective. |
| Log and event investigation | Container Insights and KQL | You need stdout or stderr logs, Kubernetes events, or historical correlation across pods and nodes. | Logs answer “why” better than metrics, but they are not a replacement for low-latency alert metrics. |

### Practical interpretation guidance

- Prefer Azure Monitor platform metrics for broad health alerts such as node pressure, node count drift, or cluster-wide phase counts.
- Prefer Managed Prometheus for Prometheus-native questions such as API latency histograms, per-container CPU rate, CoreDNS latency, or label-aware workload slicing.
- Prefer Container Insights when the metric tells you a pod is unhealthy but you still need events or logs to identify the failure mode.

### Label, scrape, and retention cautions

- Treat label count as a design choice. Every added label can multiply time-series count and make Grafana dashboards slower and more expensive to reason about.
- Keep scrape interpretation realistic: a missing Prometheus series can mean the target was unavailable, filtered, or outside the collected scrape scope, not only that the workload was healthy.
- Retention and query experience differ by telemetry type. Use this page to choose the right store, and use the linked operations and KQL pages for setup and investigation details.

## Usage Notes

- This is an interpretation page, not a setup guide. For enablement steps and workspace wiring, use [Monitoring and Logging](../../operations/monitoring-logging.md).
- Do not turn every Kubernetes label into a dashboard split. Start with node pool, namespace, workload, or route only when they answer a real question.
- For reusable investigations, pivot from Grafana or Azure Metrics into the [KQL query packs](../../troubleshooting/kql/index.md) instead of embedding large query libraries here.

## See Also

- [Cluster Metrics](cluster-metrics.md)
- [Node Metrics](node-metrics.md)
- [Pod and Container Metrics](pod-container-metrics.md)
- [Ingress and Networking Metrics](ingress-networking-metrics.md)
- [Autoscaler Metrics](autoscaler-metrics.md)
- [Monitoring and Logging](../../operations/monitoring-logging.md)
- [KQL Query Packs](../../troubleshooting/kql/index.md)

## Sources

- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [Azure Monitor managed service for Prometheus overview](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/prometheus-metrics-overview)
- [Monitor AKS with Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
