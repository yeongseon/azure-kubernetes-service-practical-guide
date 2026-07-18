# Control Plane Query Pack

This query pack focuses on Azure Kubernetes Service control-plane evidence. Use it when API requests, admission, audit activity, or autoscaler decisions point to a cluster-management problem instead of a workload-only failure.

## Queries

| Query | Focus | Tables |
| :--- | :--- | :--- |
| [API Server Health and Latency](api-server-health-latency.md) | Request latency, throttling, and response-code errors | `AzureDiagnostics`, `AKSControlPlane` |
| [Audit Log Analysis](audit-log-analysis.md) | RBAC denies, admission failures, ServiceAccount misuse, namespace activity | `AzureDiagnostics`, `AKSAudit`, `AKSAuditAdmin` |
| [Cluster Autoscaler Decisions](cluster-autoscaler-decisions.md) | Scale-up, scale-down, no-scale reasons, node-pool lag | `AzureDiagnostics`, `AKSControlPlane` |

## Usage Notes

*   These queries depend on AKS control-plane resource logs. If no diagnostic setting exists, the queries return no data.
*   Prefer resource-specific mode when possible so `AKSControlPlane`, `AKSAudit`, and `AKSAuditAdmin` tables are available alongside the legacy `AzureDiagnostics` pattern.
*   Because control-plane log payloads can differ by category and mode, several queries normalize the record into a `RawLog` string first and then extract fields.

## See Also

*   [KQL Query Packs](../index.md)
*   [Diagnostic Settings](../../../operations/diagnostic-settings.md)
*   [Control Plane](../../first-10-minutes/control-plane.md)

## Sources

*   [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
*   [AKS monitoring data reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
*   [Query container logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
