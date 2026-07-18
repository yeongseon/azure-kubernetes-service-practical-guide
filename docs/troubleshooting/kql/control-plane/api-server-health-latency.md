# API Server Health and Latency

Use these queries when `kubectl`, controllers, or admission webhooks feel slow even though nodes and pods still look healthy.

## Query Purpose

These queries help you separate API-server latency, throttling, and error-rate symptoms. They are intended for AKS control-plane logs collected through diagnostic settings.

## Required Tables

- `AzureDiagnostics` - Legacy Azure diagnostics mode for AKS resource logs.
- `AKSControlPlane` - Resource-specific mode for AKS control-plane logs.

## Query

### 1) API server request latency p95 by verb

```kusto
let lookback = 30m;
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category == "kube-apiserver"
    | extend RawLog = tostring(pack_all())
),
(
    AKSControlPlane
    | where TimeGenerated > ago(lookback)
    | where Category == "kube-apiserver"
    | extend RawLog = tostring(pack_all())
)
| extend Verb = coalesce(
        extract(@'"verb"\s*:\s*"([^"]+)"', 1, RawLog),
        extract(@'verb[=:"]+([A-Za-z]+)', 1, RawLog),
        "unknown"
    )
| extend RequestUri = coalesce(
        extract(@'"requestURI"\s*:\s*"([^"]+)"', 1, RawLog),
        extract(@'requestURI[=:"]+([^",\s]+)', 1, RawLog),
        "unknown"
    )
| extend DurationMs = todouble(coalesce(
        extract(@'"requestReceivedTimestamp"', 0, RawLog),
        ""
    ))
| extend DurationMs = coalesce(
        todouble(extract(@'"latency"\s*:\s*([0-9.]+)', 1, RawLog)),
        todouble(extract(@'"durationMs"\s*:\s*([0-9.]+)', 1, RawLog)),
        todouble(extract(@'latency[=:"]+([0-9.]+)', 1, RawLog)),
        todouble(extract(@'duration[=:"]+([0-9.]+)', 1, RawLog))
    )
| where isnotnull(DurationMs)
| summarize Requests = count(), P95LatencyMs = percentile(DurationMs, 95), P99LatencyMs = percentile(DurationMs, 99) by Verb
| order by P95LatencyMs desc
```

### 2) API server throttling and request flood detection (429)

```kusto
let lookback = 30m;
union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category == "kube-apiserver"
    | extend RawLog = tostring(pack_all())
),
(
    AKSControlPlane
    | where TimeGenerated > ago(lookback)
    | where Category == "kube-apiserver"
    | extend RawLog = tostring(pack_all())
)
| extend Verb = coalesce(
        extract(@'"verb"\s*:\s*"([^"]+)"', 1, RawLog),
        extract(@'verb[=:"]+([A-Za-z]+)', 1, RawLog),
        "unknown"
    )
| extend ResponseCode = toint(coalesce(
        extract(@'"code"\s*:\s*([0-9]{3})', 1, RawLog),
        extract(@'"statusCode"\s*:\s*([0-9]{3})', 1, RawLog),
        extract(@'code[=:"]+([0-9]{3})', 1, RawLog)
    ))
| where ResponseCode == 429 or RawLog has_any ("Too many requests", "throttl", "rate limit")
| summarize ThrottledRequests = count(), Sample = any(RawLog) by bin(TimeGenerated, 5m), Verb
| order by TimeGenerated desc, ThrottledRequests desc
```

### 3) API server error rate by response code

```kusto
let lookback = 30m;
let base = union isfuzzy=true
(
    AzureDiagnostics
    | where TimeGenerated > ago(lookback)
    | where ResourceType == "MANAGEDCLUSTERS"
    | where Category == "kube-apiserver"
    | extend RawLog = tostring(pack_all())
),
(
    AKSControlPlane
    | where TimeGenerated > ago(lookback)
    | where Category == "kube-apiserver"
    | extend RawLog = tostring(pack_all())
);
let parsed = base
| extend ResponseCode = toint(coalesce(
        extract(@'"code"\s*:\s*([0-9]{3})', 1, RawLog),
        extract(@'"statusCode"\s*:\s*([0-9]{3})', 1, RawLog),
        extract(@'code[=:"]+([0-9]{3})', 1, RawLog)
    ))
| where isnotnull(ResponseCode);
let TotalRequests = toscalar(parsed | summarize count());
parsed
| summarize Requests = count() by ResponseCode
| extend ErrorRatePercent = round((todouble(Requests) * 100.0) / todouble(TotalRequests), 2)
| order by ResponseCode asc
| project ResponseCode, Requests, ErrorRatePercent
```

## Expected Interpretation

- **Latency query**: sustained `P95LatencyMs` growth by `get`, `list`, or `watch` often points to control-plane pressure or noisy clients rather than pod CPU pressure alone.
- **429 query**: repeated spikes usually mean clients are overrunning API budgets, especially during controller storms, bad retry loops, or broad namespace scans.
- **Error-rate query**: a rise in 5xx codes indicates API-server-side instability; a rise in 4xx codes often indicates client or RBAC mistakes.

## Assumptions and Limits

- These queries require an AKS diagnostic setting that includes `kube-apiserver`.
- Field extraction is intentionally tolerant because payload shapes differ between Azure diagnostics mode and resource-specific mode.
- Some clusters emit richer latency details through control-plane metrics or Prometheus histograms than through logs alone. Use this page with control-plane metrics and Prometheus when available.

## See Also

- [Control Plane Query Pack](index.md)
- [Control Plane](../../first-10-minutes/control-plane.md)
- [Diagnostic Settings](../../../operations/diagnostic-settings.md)

## Sources

- [Monitor AKS](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)
- [AKS monitoring data reference](https://learn.microsoft.com/en-us/azure/aks/monitor-aks-reference)
- [Query container logs in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-log-query)
