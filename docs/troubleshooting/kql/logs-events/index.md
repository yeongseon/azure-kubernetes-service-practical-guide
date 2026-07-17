# Logs & Events Query Pack

Perform container log error mining and Kubernetes event triage using Azure Monitor Container insights.

## Queries

| Query | Focus | Tables |
| :--- | :--- | :--- |
| [Container Errors](container-errors.md) | Error patterns in container logs | `ContainerLogV2` |
| [OOMKilled Events](oomkilled-events.md) | Out-of-memory kills | `KubeEvents`, `KubePodInventory` |
| [Warning Events](warning-events.md) | Warning-event overview | `KubeEvents` |

## Usage Notes
- **Log Analytics Workspace**: All queries must be executed within the context of the Log Analytics workspace where your AKS cluster sends its telemetry.
- **Retention**: Be aware that logs and events are subject to your workspace retention settings (default is often 30 days).
- **Permissions**: You need the `Monitoring Reader` role or higher to run these queries in the Azure portal.

## See Also
- [KQL Query Packs](../index.md)
- [Troubleshooting Overview](../../index.md)
- [Troubleshooting Playbooks](../../playbooks/index.md)

## Sources
- [https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
- [https://learn.microsoft.com/en-us/azure/aks/monitor-aks](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
