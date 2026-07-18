---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/load-balancer-standard
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "The AKS standard load balancer provides outbound connections to cluster nodes by translating a node's private IP address to a public IP address in its outbound pool."
      source: https://learn.microsoft.com/en-us/azure/aks/load-balancer-standard
      verified: true
    - claim: "When a public IP address is added as a frontend IP to a load balancer, 64,000 ports are eligible for SNAT."
      source: https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections
      verified: true
    - claim: "New outbound connections to a destination IP fail when SNAT port exhaustion occurs and succeed again when a port becomes available."
      source: https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections
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
- [Use a public Standard Load Balancer in AKS](https://learn.microsoft.com/en-us/azure/aks/load-balancer-standard)
- [Source Network Address Translation (SNAT) for outbound connections](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections)
