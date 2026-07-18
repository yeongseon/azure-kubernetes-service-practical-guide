---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/cluster-autoscaler-overview
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/concepts-scale
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "The Horizontal Pod Autoscaler monitors resource demand and automatically scales the number of pods."
      source: https://learn.microsoft.com/en-us/azure/aks/concepts-scale
      verified: true
    - claim: "The cluster autoscaler adjusts the number of nodes in a node pool based on requested compute resources and unschedulable pods."
      source: https://learn.microsoft.com/en-us/azure/aks/concepts-scale
      verified: true
    - claim: "If cluster autoscaler scheduling simulation determines that restrictive topology spread constraints would still prevent a pod from being scheduled on a new node, it does not attempt to scale up."
      source: https://learn.microsoft.com/en-us/azure/aks/cluster-autoscaler-overview
      verified: true
    - claim: "AKS exposes `cluster_autoscaler_unschedulable_pods_count` as a cluster autoscaler metric for unschedulable pods."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference
      verified: true
---

# Autoscaler Metrics

Autoscaler metrics explain whether AKS scaled too slowly, refused to scale, or scaled exactly as instructed by workload requests and policy.

## Topic Groups

### HPA and cluster autoscaler signals

| Metric | Source | What it means | Common use | Denominator / cardinality notes |
|---|---|---|---|---|
| `kube_hpa_status_current_replicas` | Managed Prometheus | Current replica count owned by an HPA. | Confirm whether HPA is reacting to load or sitting at a floor or ceiling. | Compare with `minReplicas`, `maxReplicas`, and the target utilization metric; the count alone does not tell you whether scaling is healthy. |
| `cluster_autoscaler_unschedulable_pods` / `cluster_autoscaler_unschedulable_pods_count` | Managed Prometheus and AKS metric surfaces | Number of pods the cluster autoscaler sees as unschedulable. | Detect when pending pods are waiting on node growth or when scale-out is blocked. | Track duration as well as count. A short spike during normal scale-up is different from a flat plateau. |
| HPA target signals (for example CPU or memory utilization) | Azure Monitor platform metrics and Managed Prometheus | The demand signal that causes HPA to raise or lower replicas. | Validate whether replica changes match the intended utilization target. | Always interpret with pod requests; HPA decisions depend on requested resources, not only on raw usage. |
| Node count and pool capacity context | Azure Monitor platform metrics | Whether node growth actually occurred after pods became unschedulable. | Separate “HPA asked for more pods” from “cluster autoscaler could not add nodes.” | Review per-pool bounds, subnet/IP availability, and quota limits together. |

### Interpretation priorities

- HPA health is about both demand and boundaries. A stable `current_replicas` value can mean either equilibrium or a hidden `maxReplicas` ceiling.
- Unschedulable pod metrics become actionable only when they persist long enough to show that cluster growth is blocked or insufficient.
- If scale-up never happens, inspect requests, topology constraints, quotas, and subnet/IP capacity before changing autoscaler settings.

## Usage Notes

- Use autoscaler metrics together with node and pod metrics; scale failures are often visible in all three layers.
- For alerting, favor sustained unschedulable-pod conditions over brief spikes during normal demand transitions.
- Query packs and playbooks are better than one-off charts when you need to explain why scale-up was denied.

## See Also

- [Cluster Metrics](cluster-metrics.md)
- [Node Metrics](node-metrics.md)
- [Cluster Autoscaler Issues](../../troubleshooting/playbooks/cluster-autoscaler-issues.md)
- [Scaling Failure](../../troubleshooting/playbooks/operations/scaling-failure.md)
- [Pending Pods](../../troubleshooting/playbooks/pod-issues/pending-pods.md)
- [Pending Pods KQL](../../troubleshooting/kql/workloads/pending-pods.md)
- [Monitoring and Logging](../../operations/monitoring-logging.md)

## Sources

- [AKS monitoring reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Cluster autoscaler overview](https://learn.microsoft.com/en-us/azure/aks/cluster-autoscaler-overview)
- [Scale applications in AKS](https://learn.microsoft.com/en-us/azure/aks/concepts-scale)
