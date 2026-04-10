---
hide:
  - toc
content_sources:
  diagrams:
  - id: troubleshooting-playbooks-ingress-not-working
    type: flowchart
    source: self-generated
    justification: Diagnostic flow synthesized from Microsoft Learn troubleshooting
      guidance linked in this page.
    based_on:
    - https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes
    - https://learn.microsoft.com/en-us/azure/aks/cluster-autoscaler
    - https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
    - https://learn.microsoft.com/en-us/azure/aks/concepts-network
---



# Ingress Not Working

## 1. Summary

Use this playbook when external or internal traffic does not reach the intended service through AKS ingress. Common root causes include wrong ingress class, AGIC or ingress-nginx controller health issues, TLS secret mismatch, backend service misconfiguration, or DNS pointing to the wrong frontend endpoint.

**Typical incident window**: 10-20 minutes to establish whether the issue is workload-specific, node-specific, or cluster-wide.
**Time to resolution**: 30 minutes to several hours depending on whether the fix is manifest-level, node-level, or Azure control-plane level.

### Symptoms

- Clients receive `404`, `502`, `503`, TLS handshake failures, or timeouts through the expected hostname.
- The application is reachable directly as a ClusterIP or pod port-forward, but not through ingress.
- Application Gateway or load balancer health probes report backends unhealthy.
- Container Insights shows controller errors or no matching ingress events for the affected namespace.

### Diagnostic flowchart

<!-- diagram-id: troubleshooting-playbooks-ingress-not-working -->
```mermaid
flowchart TD
    A[Reported symptom] --> B{Can the object be reproduced now?}
    B -->|No| C[Use recent events, Container Insights, and rollout history]
    B -->|Yes| D[Capture current state with kubectl and Azure CLI]
    D --> E{Is the issue isolated to one workload or node pool?}
    E -->|Workload| F[Check image, probes, config, and service wiring]
    E -->|Node pool| G[Check node health, autoscaler, subnet, and VMSS state]
    F --> H[Validate with KQL and controller logs]
    G --> H
    H --> I[Apply targeted fix and verify telemetry returns to baseline]
```

## 2. Common Misreadings

| Observation | Often Misread As | Actually Means |
|---|---|---|
| Symptom appears in one namespace | Entire cluster outage | The issue may still be isolated to one rollout, one pool, or one ingress class. |
| Azure portal shows cluster healthy | Workload path is healthy | Control plane health does not prove pod, node, or ingress behavior. |
| Restart or reschedule seems to help briefly | Root cause is fixed | Many AKS issues recur until the underlying manifest, node, or network condition is corrected. |
| Monitoring has partial data | Monitoring is the problem | Partial Container Insights data is itself useful evidence about scope and timing. |

## 3. Competing Hypotheses

| Hypothesis | Likelihood | Key Discriminator |
|---|---|---|
| Wrong ingress class or controller is watching the object | High | Ingress object exists, but controller logs never mention it or another controller owns the class. |
| Backend service or endpoint mapping is wrong | High | Ingress points to a service without healthy endpoints or wrong target port. |
| TLS or certificate configuration is invalid | Medium | Controller logs and client output show handshake or secret read errors. |
| DNS or frontend endpoint drift | Medium | Hostname resolves to the wrong public IP, private IP, or Application Gateway listener. |

## 4. What to Check First

1. **Confirm the current object state from Kubernetes**

    ```bash
    kubectl get pods \
        --all-namespaces \
        --output wide
    ```

2. **Describe the affected object to capture recent events**

    ```bash
    kubectl describe pod <pod-name> \
        --namespace <namespace>
    ```

3. **Check AKS cluster and node pool configuration from Azure**

    ```bash
    az aks show \
        --resource-group "$RG" \
        --name "$CLUSTER_NAME" \
        --query "{name:name,provisioningState:provisioningState,kubernetesVersion:kubernetesVersion,nodeResourceGroup:nodeResourceGroup}" \
        --output json
    ```

4. **List node pools and autoscaler settings**

    ```bash
    az aks nodepool list \
        --resource-group "$RG" \
        --cluster-name "$CLUSTER_NAME" \
        --output table
    ```

5. **Run a fast Container Insights control query**

    ```bash
    az monitor log-analytics query \
        --workspace "$WORKSPACE_ID" \
        --analytics-query "KubePodInventory | where TimeGenerated > ago(15m) | summarize Restarts=sum(ContainerRestartCount) by Namespace | order by Restarts desc" \
        --timespan "PT15M"
    ```

## 5. Evidence to Collect

### 5.1 KQL Queries

```kusto
KubePodInventory
| where TimeGenerated > ago(30m)
| summarize Restarts=max(ContainerRestartCount), LastSeen=max(TimeGenerated) by ClusterName, Namespace, PodName, ContainerName
| order by Restarts desc
```

| Column | Example value | Interpretation |
|---|---|---|
| `Restarts` | `14` | Confirms the issue is current and identifies which container is unstable. |
| `LastSeen` | `2026-04-07 09:41:00` | Shows how fresh the inventory signal is. |
| `Namespace` | `payments` | Helps isolate whether blast radius is limited. |

!!! tip "How to Read This"
    Start by proving scope. If restart or state anomalies are limited to one namespace or one pool, avoid cluster-wide changes first.

```kusto
ContainerLogV2
| where TimeGenerated > ago(30m)
| summarize LogLines=count(), LastSeen=max(TimeGenerated) by Namespace, PodName
| order by LastSeen desc
```

| Column | Example value | Interpretation |
|---|---|---|
| `LogLines` | `152` | Confirms whether the pod is emitting logs during failure. |
| `LastSeen` | `recent timestamp` | Stale logs can indicate the container never reaches full runtime. |

!!! tip "How to Read This"
    Pair this query with `kubectl logs --previous` so you do not confuse current healthy logs with the failing previous container instance.

```kusto
KubeEvents
| where TimeGenerated > ago(30m)
| where Reason in ("Failed", "BackOff", "Unhealthy", "NodeNotReady", "FailedScheduling")
| project TimeGenerated, Namespace, Name, Reason, Message
| order by TimeGenerated desc
```

| Column | Example value | Interpretation |
|---|---|---|
| `Reason` | `BackOff` | Indicates repeated restart attempts or scheduling failures depending on the object. |
| `Message` | `Back-off restarting failed container` | Often provides the shortest path to the likely hypothesis. |

!!! tip "How to Read This"
    Events often age out faster than logs. Capture them early in the incident before recreating pods or nodes.

### 5.2 CLI Investigation

```bash
kubectl logs <pod-name> \
    --namespace <namespace> \
    --previous
```

Interpretation: previous logs are usually more valuable than current logs during restart loops because they contain the container exit path.

```bash
kubectl get events \
    --all-namespaces \
    --sort-by=.lastTimestamp
```

Interpretation: look for probe failures, image pull errors, `FailedScheduling`, `NodeNotReady`, or backend controller warnings near the incident start time.

```bash
az vmss list-instances \
    --resource-group "$NODE_RESOURCE_GROUP" \
    --name "$VMSS_NAME" \
    --query "[].{instanceId:instanceId,provisioningState:provisioningState,latestModelApplied:latestModelApplied}" \
    --output table
```

Interpretation: when the problem is node- or ingress-related, VMSS state and model drift provide important Azure-side evidence.

## 6. Validation and Disproof by Hypothesis

### Wrong ingress class or controller is watching the object

**Proves if**: Kubernetes events, previous logs, and Azure-side state all align around this hypothesis.

**Disproves if**: Another signal explains the timing more directly or the expected discriminator is missing.

```bash
kubectl describe pod <pod-name> \
    --namespace <namespace>
```

### Backend service or endpoint mapping is wrong

**Proves if**: Kubernetes events, previous logs, and Azure-side state all align around this hypothesis.

**Disproves if**: Another signal explains the timing more directly or the expected discriminator is missing.

```bash
kubectl describe pod <pod-name> \
    --namespace <namespace>
```

### TLS or certificate configuration is invalid

**Proves if**: Kubernetes events, previous logs, and Azure-side state all align around this hypothesis.

**Disproves if**: Another signal explains the timing more directly or the expected discriminator is missing.

```bash
kubectl describe pod <pod-name> \
    --namespace <namespace>
```

### DNS or frontend endpoint drift

**Proves if**: Kubernetes events, previous logs, and Azure-side state all align around this hypothesis.

**Disproves if**: Another signal explains the timing more directly or the expected discriminator is missing.

```bash
kubectl describe pod <pod-name> \
    --namespace <namespace>
```

## 7. Likely Root Cause Patterns

| Pattern | Evidence | Resolution |
|---|---|---|
| Manifest drift after a rollout | New revision correlates with events, logs, or controller errors | Revert or patch the manifest and validate against staging first |
| Pool-level capacity mismatch | Pending pods, high utilization, or `NotReady` nodes align to one pool | Tune requests, autoscaler limits, or node pool shape |
| Network or DNS drift | Ingress, image pull, or dependency lookups fail while pods otherwise look normal | Correct DNS, NSG, route, or ingress controller configuration |
| Operational blind spot | Teams deleted or recreated resources before collecting evidence | Add a first-response checklist and automation for evidence capture |

## 8. Immediate Mitigations and Step-by-Step Resolution

1. Confirm the ingress class and controller ownership first.
2. Validate the service selector, endpoints, and backend health before changing DNS.
3. Repair TLS secrets, listeners, or Application Gateway associations only after backend reachability is proven.
4. Correct DNS records and TTL strategy when infrastructure targets have changed.
5. Verify success from inside the cluster, from the frontend, and from the client network path.

Example resolution commands:

```bash
kubectl rollout restart deployment/<deployment-name> \
    --namespace <namespace>
```

```bash
az aks nodepool update \
    --resource-group "$RG" \
    --cluster-name "$CLUSTER_NAME" \
    --name "$NODEPOOL_NAME" \
    --max-count 10
```

## 9. Prevention Checklist

- [ ] Create saved Container Insights queries for the symptom family and link them in the team runbook.
- [ ] Require long-flag CLI examples and standardized evidence capture in incident response docs.
- [ ] Review ingress, autoscaler, probes, and node pool settings during every production readiness review.
- [ ] Alert on restart spikes, `NotReady` nodes, and `FailedScheduling` events before customers report impact.
- [ ] Document which changes require platform-team approval, especially around networking, ingress, and security policy.

## See Also

- [Ingress Failure](connectivity/ingress-failure.md)
- [Networking](../../best-practices/networking.md)
- [Lab 02: Application Gateway Ingress](../../tutorials/lab-guides/lab-02-application-gateway-ingress.md)

## Sources

- [Troubleshoot / Azure / Azure Kubernetes / Welcome Azure Kubernetes](https://learn.microsoft.com/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)
- [Azure / Aks / Cluster Autoscaler](https://learn.microsoft.com/azure/aks/cluster-autoscaler)
- [Azure / Azure Monitor / Containers / Container Insights Overview](https://learn.microsoft.com/azure/azure-monitor/containers/container-insights-overview)
- [Azure / Aks / Concepts Network](https://learn.microsoft.com/azure/aks/concepts-network)
