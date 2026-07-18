---
content_sources:
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/limit-egress-traffic
  - type: mslearn-adapted
    url: https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "AKS clusters with restricted egress still require outbound access to the required AKS dependencies and FQDNs."
      source: https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress
      verified: true
    - claim: "Network-isolated or otherwise restricted-egress AKS designs must deliberately provide image access paths rather than assuming public registry access will work by default."
      source: https://learn.microsoft.com/en-us/azure/aks/limit-egress-traffic
      verified: true
---

# Image Pull Fails in Restricted Egress

## Symptom

Pods stay in `ImagePullBackOff` or `ErrImagePull` after deployment in a cluster that uses restricted egress, forced tunneling, Azure Firewall, proxy routing, or private endpoints.

## Possible Causes

- Wrong image reference, missing tag, or broken pull secret.
- Azure Container Registry private endpoint exists, but private DNS is missing or still resolves publicly.
- Firewall, UDR, or proxy blocks required ACR, Microsoft Container Registry, or other AKS dependency endpoints.
- Required `mcr.microsoft.com` or related artifact FQDNs are not allowed.
- Proxy interception blocks TLS or misses the correct `no-proxy` exclusions.
- Private endpoints, pod CIDRs, or service CIDRs are not bypassed correctly in the proxy path.

## Diagnosis Steps

1. Prove whether the failure is an image or authentication problem before chasing networking.

    ```bash
    kubectl describe pod <pod-name> --namespace <namespace>
    kubectl get events --sort-by=.lastTimestamp
    ```

2. Confirm the cluster egress model and networking plugin.

    ```bash
    az aks show \
        --resource-group "$RG" \
        --name "$CLUSTER_NAME" \
        --query "{outboundType:networkProfile.outboundType,networkPlugin:networkProfile.networkPlugin}" \
        --output yaml
    ```

3. Inspect the registry exposure model.

    ```bash
    az acr show \
        --resource-group "$ACR_RG" \
        --name "$ACR_NAME" \
        --query "{loginServer:loginServer,publicNetworkAccess:publicNetworkAccess}" \
        --output yaml

    az network private-endpoint-connection list \
        --id "/subscriptions/<subscription-id>/resourceGroups/$ACR_RG/providers/Microsoft.ContainerRegistry/registries/$ACR_NAME" \
        --output table
    ```

4. Check whether core platform pods show a wider egress problem.

    ```bash
    kubectl get pods --namespace kube-system --output wide
    ```

5. Compare the failing image hostname with the allowed FQDNs and any proxy bypass list for private endpoints, pod CIDRs, and service CIDRs.

## Resolution

- Fix the image name, tag, or pull secret first when the error is authentication- or manifest-related.
- Add or repair the ACR private endpoint and its private DNS zone links when the registry should stay private.
- Allow the required AKS, MCR, and ACR FQDNs through firewall, UDR, or proxy controls.
- Add proxy bypass entries for private endpoints, pod CIDRs, service CIDRs, and registry private DNS names.
- Prefer ACR private endpoints for restricted-egress clusters rather than relying on public registry paths.

## Prevention

- Standardize registry patterns for restricted-egress clusters before onboarding workloads.
- Keep the required outbound dependency list under change control with the network team.
- Validate proxy `no-proxy` coverage whenever private endpoints or CIDR ranges change.
- Treat image pull failures as both application onboarding checks and platform egress checks.

## See Also

- [Outbound Networking](../../../platform/outbound-networking.md)
- [Private Cluster API Connectivity](../../../best-practices/private-cluster-api-connectivity.md)
- [Webhook / Control-Plane Calls Blocked](webhook-control-plane-blocked.md)

## Sources

- [Use a network isolated cluster in AKS](https://learn.microsoft.com/en-us/azure/aks/limit-egress-traffic)
- [Control egress traffic for cluster nodes in AKS](https://learn.microsoft.com/en-us/azure/aks/outbound-rules-control-egress)
