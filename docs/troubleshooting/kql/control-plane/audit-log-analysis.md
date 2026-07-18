# Audit Log Analysis

Use these queries when an incident might involve RBAC, admission control, namespace-level changes, or risky ServiceAccount usage.

## Query Purpose

These queries mine AKS audit streams for security and governance evidence. They emphasize forbidden requests, webhook failures, privilege-escalation patterns, and activity summaries that speed root-cause narrowing during an incident.

## Required Tables

- `AzureDiagnostics` - Legacy Azure diagnostics mode for `kube-audit` and `kube-audit-admin`.
- `AKSAudit` - Resource-specific mode for full audit data.
- `AKSAuditAdmin` - Resource-specific mode for admin-scoped audit data excluding `get` and `list`.

## Query

### 1) RBAC deny detection (`forbidden`)

```kusto
let lookback = 1h;
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category in ("kube-audit", "kube-audit-admin")
    | extend RawLog = tostring(pack_all())
),
(
    AKSAudit
    | where TimeGenerated > ago(lookback)
    | extend RawLog = tostring(pack_all())
),
(
    AKSAuditAdmin
    | where TimeGenerated > ago(lookback)
    | extend RawLog = tostring(pack_all())
)
| where RawLog has "forbidden"
| extend UserName = coalesce(
        extract(@'"username"\s*:\s*"([^"]+)"', 1, RawLog),
        extract(@'user[=:"]+([^",\s]+)', 1, RawLog),
        "unknown"
    )
| extend Verb = coalesce(extract(@'"verb"\s*:\s*"([^"]+)"', 1, RawLog), "unknown")
| extend Namespace = coalesce(extract(@'"namespace"\s*:\s*"([^"]+)"', 1, RawLog), "cluster-scope")
| extend Resource = coalesce(extract(@'"resource"\s*:\s*"([^"]+)"', 1, RawLog), "unknown")
| summarize DeniedRequests = count(), Sample = any(RawLog) by UserName, Verb, Namespace, Resource
| order by DeniedRequests desc
```

### 2) Admission webhook failure detection

```kusto
let lookback = 1h;
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category in ("kube-audit", "kube-audit-admin")
    | extend RawLog = tostring(pack_all())
),
(
    AKSAudit
    | where TimeGenerated > ago(lookback)
    | extend RawLog = tostring(pack_all())
),
(
    AKSAuditAdmin
    | where TimeGenerated > ago(lookback)
    | extend RawLog = tostring(pack_all())
)
| where RawLog has_any ("admission webhook", "failed calling webhook", "denied the request", "timeout")
| extend Namespace = coalesce(extract(@'"namespace"\s*:\s*"([^"]+)"', 1, RawLog), "cluster-scope")
| extend Webhook = coalesce(
        extract(@'webhook[=:"]+([^",\s]+)', 1, RawLog),
        extract(@'"name"\s*:\s*"([^"]*webhook[^"]*)"', 1, RawLog),
        "unknown"
    )
| summarize Failures = count(), Sample = any(RawLog) by Namespace, Webhook, bin(TimeGenerated, 10m)
| order by TimeGenerated desc, Failures desc
```

### 3) ServiceAccount privilege-escalation attempts

```kusto
let lookback = 24h;
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category in ("kube-audit", "kube-audit-admin")
    | extend RawLog = tostring(pack_all())
),
(
    AKSAudit
    | where TimeGenerated > ago(lookback)
    | extend RawLog = tostring(pack_all())
),
(
    AKSAuditAdmin
    | where TimeGenerated > ago(lookback)
    | extend RawLog = tostring(pack_all())
)
| where RawLog has "system:serviceaccount:"
| where RawLog has_any ("clusterrolebindings", "rolebindings", "escalate", "impersonate", "serviceaccounts/token")
| extend ServiceAccount = coalesce(
        extract(@'system:serviceaccount:[^:\"]+:([^\"]+)', 1, RawLog),
        "unknown"
    )
| extend Namespace = coalesce(extract(@'"namespace"\s*:\s*"([^"]+)"', 1, RawLog), "cluster-scope")
| extend Verb = coalesce(extract(@'"verb"\s*:\s*"([^"]+)"', 1, RawLog), "unknown")
| summarize Events = count(), Sample = any(RawLog) by ServiceAccount, Namespace, Verb
| order by Events desc
```

### 4) Namespace-scoped activity summary

```kusto
let lookback = 6h;
let targetNamespace = "default";
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category in ("kube-audit", "kube-audit-admin")
    | extend RawLog = tostring(pack_all())
),
(
    AKSAudit
    | where TimeGenerated > ago(lookback)
    | extend RawLog = tostring(pack_all())
),
(
    AKSAuditAdmin
    | where TimeGenerated > ago(lookback)
    | extend RawLog = tostring(pack_all())
)
| extend Namespace = coalesce(extract(@'"namespace"\s*:\s*"([^"]+)"', 1, RawLog), "cluster-scope")
| where Namespace == targetNamespace
| extend UserName = coalesce(extract(@'"username"\s*:\s*"([^"]+)"', 1, RawLog), "unknown")
| extend Verb = coalesce(extract(@'"verb"\s*:\s*"([^"]+)"', 1, RawLog), "unknown")
| extend Resource = coalesce(extract(@'"resource"\s*:\s*"([^"]+)"', 1, RawLog), "unknown")
| summarize Requests = count(), DistinctUsers = dcount(UserName) by Verb, Resource
| order by Requests desc
```

## Expected Interpretation

- **RBAC denies**: repeated denies from one user or service account usually indicate a mis-scoped role, stale kubeconfig, or rollout that changed identities.
- **Admission failures**: clustered failures often point to webhook availability, TLS, DNS, or policy configuration drift.
- **Privilege-escalation attempts**: even a single suspicious write to bindings, impersonation paths, or token subresources deserves review.
- **Namespace summary**: unusually high write activity in one namespace is a fast way to spot noisy deployments, automation loops, or emergency manual changes.

## Assumptions and Limits

- These queries require `kube-audit` and/or `kube-audit-admin` in the diagnostic setting.
- `kube-audit-admin` intentionally excludes `get` and `list`, so low-noise write-path analysis is often easier there than in full audit logs.
- Because audit payloads are nested and differ by collection mode, regex extraction may need tuning for your workspace schema.

## See Also

- [Control Plane Query Pack](index.md)
- [Diagnostic Settings](../../../operations/diagnostic-settings.md)
- [Baseline Alerts](../../../operations/baseline-alerts.md)

## Sources

- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [AKS monitoring data reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Query container logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
