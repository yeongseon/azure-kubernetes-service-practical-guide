---
content_sources:
  diagrams:
  - id: operations-monitoring-logging
    type: flowchart
    source: mslearn-adapted
    mslearn_url: https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
    based_on:
    - https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
    - https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-data-collection-configure
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
    - claim: "AKS control plane logs are implemented as Azure Monitor resource logs and are collected only after you create a diagnostic setting."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
    - claim: "Container insights collects stdout and stderr logs and Kubernetes events from each node in an AKS cluster."
      source: https://learn.microsoft.com/en-us/azure/aks/monitor-aks
      verified: true
---




# Monitoring and Logging

AKS observability must cover cluster state, node health, workload health, and control-plane-related signals. Effective monitoring is the difference between guessing and diagnosing.

## Prerequisites

- Log Analytics workspace or equivalent telemetry backend is available.
- Metrics Server and/or Azure Monitor pipelines are configured.
- Alert ownership and escalation paths are defined.

## When to Use

- Building the baseline observability stack.
- Expanding alerts for new critical workloads.
- Diagnosing incidents with cluster and node evidence.

## Procedure
<!-- diagram-id: operations-monitoring-logging -->
```mermaid
flowchart TD
    A[Cluster Metrics] --> B[Logs]
    B --> C[Alerts]
    C --> D[Dashboards]
    D --> E[Incident Triage]
```


```bash
az aks enable-addons \
    --resource-group "$RG" \
    --name "$CLUSTER_NAME" \
    --addons monitoring
kubectl top nodes
kubectl top pods --all-namespaces
kubectl get events --all-namespaces --sort-by=.lastTimestamp
```

| Command | Purpose |
| --- | --- |
| `az aks enable-addons` | Enable the Container Insights monitoring add-on. |
| `--resource-group` | Resource group that contains the AKS cluster. |
| `--name` | Name of the AKS cluster. |
| `--addons` | Add-on to enable, monitoring for Container Insights. |
| `kubectl top nodes` | Show current node CPU and memory usage. |
| `kubectl top pods` | Show current pod CPU and memory usage. |
| `kubectl get events` | List Kubernetes events for troubleshooting. |

## Verification

```bash
az aks show --resource-group $RG --name $CLUSTER_NAME --query addonProfiles.omsagent.enabled --output tsv
kubectl get pods --namespace kube-system
```

| Command | Purpose |
| --- | --- |
| `az aks show` | Check whether the Container Insights agent is enabled. |
| `--resource-group` | Resource group that contains the AKS cluster. |
| `--name` | Name of the AKS cluster. |
| `--query` | Selects the monitoring add-on enabled flag. |
| `--output` | Output format for the result. |
| `kubectl get pods` | List monitoring pods in the kube-system namespace. |

You can confirm the same telemetry in the Azure Portal on the cluster monitoring blades.

[[[ shot("aks-monitoring-insights") ]]]

Purpose: Confirm Container insights is collecting live node and workload telemetry after enabling the monitoring add-on.

Look for:

- **Node CPU and memory** charts show recent, non-empty data points.
- The node and pod counts match the cluster's actual topology.
- No agent health warnings are shown at the top of the blade.

Expected result: Container insights reports live utilization, confirming the monitoring pipeline is active.

Next step: Build a custom chart on the Metrics blade for a specific signal.

[[[ shot("aks-monitoring-metrics") ]]]

Purpose: Show where to build ad hoc charts from platform metrics for a specific investigation.

Look for:

- The **Scope** is the AKS cluster and the **Metric Namespace** is `Container service`.
- The chart builder lets you add a metric, aggregation, and splitting.
- The time range control reflects the window you want to inspect.

Expected result: You can compose a metric chart for any supported AKS signal and optionally pin it to a dashboard.

Next step: Configure a diagnostic setting to stream control-plane logs to Log Analytics.

[[[ shot("aks-monitoring-diagnostic-settings") ]]]

Purpose: Show where to enable streaming export of control-plane logs (API server, audit, scheduler) to a destination.

Look for:

- The blade lists log categories such as **Kubernetes API Server**, **Kubernetes Audit**, and **Cluster Autoscaler**.
- A destination (Log Analytics workspace, storage account, or event hub) can be attached.
- Any existing diagnostic settings and their destinations are visible.

Expected result: You can route control-plane logs to Log Analytics for audit and incident investigation.

Next step: Query the exported logs from the [Diagnostic Commands](../reference/diagnostic-commands.md) reference.

## Rollback / Troubleshooting

- If metrics are missing, check Metrics Server and Azure Monitor agent health.
- If control-plane KQL queries return no data, create the AKS diagnostic setting before assuming the cluster emitted no logs.
- If logs exist but are unusable, refine namespace, workload, and owner labeling.
- If alerts are noisy, fix thresholds and missing suppression logic instead of disabling visibility.
- If Prometheus dashboards are empty but Container insights works, check the Azure Monitor workspace and Grafana linkage separately from the Log Analytics workspace.

## See Also

- [Reference: Diagnostic Commands](../reference/diagnostic-commands.md)
- [Diagnostic Settings](diagnostic-settings.md)
- [Managed Prometheus](managed-prometheus.md)
- [Baseline Alerts](baseline-alerts.md)
- [Evidence Map](../troubleshooting/evidence-map.md)
- [Performance Checklist](../troubleshooting/first-10-minutes/performance.md)
- [KQL Query Packs](../troubleshooting/kql/index.md)

## Sources

- [Monitor AKS with Container insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
- [Enable monitoring for AKS clusters](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-enable)
