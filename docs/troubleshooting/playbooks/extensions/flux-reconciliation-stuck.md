---
description: Troubleshoot Flux GitOps reconciliation failures on AKS by checking source auth render errors dependency cycles and drift signals.
content_sources:
  diagrams:
    - id: troubleshooting-extensions-flux-reconciliation-stuck
      type: flowchart
      source: self-generated
      justification: Flux reconciliation diagnostic flow synthesized from Microsoft Learn Flux v2 conceptual documentation.
      based_on:
        - https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "The Flux Source controller synchronizes Git repositories."
      source: https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2
      verified: true
    - claim: "The Flux Kustomize controller applies Kustomize or raw YAML files from the source onto the cluster."
      source: https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2
      verified: true
    - claim: "A fluxConfigurations resource can create a Flux GitRepository object in the cluster."
      source: https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2
      verified: true
---

# Flux Reconciliation Stuck

## Symptom

Flux objects remain in a not-ready state, changes in Git never appear in the cluster, or resources partially apply and then stall.

## Possible Causes

- The source cannot authenticate to Git, Helm, Bucket, or Blob storage.
- The source syncs but the Kustomization render fails.
- A dependency cycle or ordering mistake blocks downstream Kustomizations.
- Multi-tenant namespace boundaries block cross-namespace references.
- Azure-side configuration changed but the agent did not reconnect cleanly.

## Diagnosis Steps

<!-- diagram-id: troubleshooting-extensions-flux-reconciliation-stuck -->
```mermaid
flowchart TD
    A[Flux reconcile stuck] --> B[Check source object status]
    B --> C{Source ready?}
    C -->|No| D[Fix auth or reachability]
    C -->|Yes| E[Check Kustomization conditions]
    E --> F{Render or apply error?}
    F -->|Yes| G[Fix manifest path dependency or schema]
    F -->|No| H[Inspect multi-tenant or drift conditions]
    H --> I[Correct namespace model or resync]
```

1. Inspect the Flux extension pods.

    ```bash
    kubectl get pods \
        --namespace flux-system
    ```

2. Inspect source objects.

    ```bash
    kubectl get gitrepositories.source.toolkit.fluxcd.io \
        --all-namespaces

    kubectl describe gitrepository <name> \
        --namespace <namespace>
    ```

3. Inspect the Kustomization state.

    ```bash
    kubectl get kustomizations.kustomize.toolkit.fluxcd.io \
        --all-namespaces

    kubectl describe kustomization <name> \
        --namespace <namespace>
    ```

4. If Helm is part of the flow, inspect Helm repository or release objects in the same namespace model.

5. Review whether the failing objects use cross-namespace source references that violate the multi-tenant pattern.

6. Compare Azure-side `fluxConfigurations` settings with the in-cluster source path and namespace expectations.

## Resolution

- Fix source credentials or network reachability for the upstream repository.
- Correct invalid Kustomize paths, render errors, or unsupported manifest changes.
- Break dependency cycles so foundational objects reconcile before dependents.
- Move source and release references into the same namespace model when multi-tenancy requires it.
- Reapply or update the Azure `fluxConfigurations` resource if Azure and cluster state drifted.

## Prevention

- Keep Git sources and Kustomizations namespace-local in shared clusters.
- Validate Kustomize render output in CI before merge.
- Model environment promotion as separate overlays instead of ad hoc path edits.
- Keep repo authentication ownership and secret rotation procedures documented.

## See Also

- [Flux GitOps Extension](../../../platform/flux-gitops-extension.md)
- [Best Practices: Platform Extensions](../../../best-practices/platform-extensions.md)
- [Resource Governance](../../../best-practices/resource-governance.md)

## Sources

- [Application deployments with GitOps (Flux v2)](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/conceptual-gitops-flux2)
