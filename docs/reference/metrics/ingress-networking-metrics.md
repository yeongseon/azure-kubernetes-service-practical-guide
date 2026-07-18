---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
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

# Ingress and Networking Metrics

Ingress and networking metrics help you decide whether traffic failures come from the frontend path, DNS latency, or outbound exhaustion.

## Topic Groups

### Traffic-path and name-resolution metrics

| Metric | Source | What it means | Common use | Denominator / cardinality notes |
|---|---|---|---|---|
| Load balancer active connections | Azure Monitor platform metric | Concurrent frontend or backend connection load on the Azure Load Balancer path used by AKS services. | Spot sudden traffic spikes, connection leaks, or unexpected load concentration on ingress paths. | Trending is more useful than absolute thresholds. Split by frontend/backend rule only when a specific service is under investigation. |
| SNAT port usage | Container Insights and Azure-side diagnostics | Outbound port consumption for egress flows. High utilization can cause intermittent outbound failures even when pods look healthy. | Validate CNI IP or egress exhaustion hypotheses for image pulls, external API calls, or DNS recursion. | The real denominator is available ports per outbound path, not node count. Review pool growth and egress design together. |
| `dns_request_duration_seconds` | Managed Prometheus | CoreDNS request latency. Increased resolution time can slow service discovery and external name lookups. | Distinguish DNS slowness from application slowness or ingress-controller defects. | Filter by server or zone only when necessary. Label-heavy DNS charts become noisy quickly. |

### Interpretation priorities

- If ingress appears broken but pod health is normal, check traffic-path and DNS metrics before changing application code.
- SNAT pressure often presents as random outbound timeouts, not as a clean cluster-wide outage.
- DNS latency is most useful as a comparative signal: look for sudden deviation from the cluster baseline.

## Usage Notes

- Azure Monitor platform metrics are usually the fastest way to confirm load balancer-side pressure.
- Use Container Insights and diagnostics when you need node-level evidence for outbound exhaustion or related event history.
- Keep Prometheus DNS charts focused on a narrow label set; CoreDNS metrics can become hard to read when over-split.

## See Also

- [Pod and Container Metrics](pod-container-metrics.md)
- [Ingress Not Working](../../troubleshooting/playbooks/ingress-not-working.md)
- [CNI IP Exhaustion](../../troubleshooting/playbooks/node-issues/cni-ip-exhaustion.md)
- [KQL Query Packs](../../troubleshooting/kql/index.md)
- [Monitoring and Logging](../../operations/monitoring-logging.md)
- [Diagnostic Commands](../diagnostic-commands.md)

## Sources

- [AKS monitoring reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [Monitor AKS with Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
