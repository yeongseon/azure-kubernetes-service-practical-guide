# Upgrades

AKS upgrades touch both Kubernetes version and node image lifecycle. A safe upgrade is a staged change with explicit pre-checks, workload validation, and rollback criteria.

## Prerequisites

- Review supported versions and target version compatibility.
- Confirm workload manifests and controllers support the target version.
- Review maintenance windows, PDBs, and cluster autoscaler settings.

## When to Use

- Moving to a supported Kubernetes version.
- Applying node image updates.
- Aligning cluster posture with security or support policy.

## Procedure

```mermaid
flowchart LR
    A[Check versions] --> B[Upgrade non-production]
    B --> C[Upgrade control plane and pools]
    C --> D[Validate workloads]
    D --> E[Repeat in production]
```


```bash
az aks get-upgrades --resource-group $RG --name $CLUSTER_NAME --output table
az aks upgrade     --resource-group $RG     --name $CLUSTER_NAME     --kubernetes-version <target-version>     --yes
kubectl get nodes
kubectl get pods -A
```

## Verification

```bash
az aks show --resource-group $RG --name $CLUSTER_NAME --query kubernetesVersion --output tsv
kubectl version
kubectl get events -A --sort-by=.lastTimestamp
```

## Rollback / Troubleshooting

- AKS does not offer a simple in-place downgrade path for every upgrade scenario, so test first.
- If workloads fail after upgrade, inspect API deprecations, CRD/controller compatibility, and PDB constraints.
- If one pool is problematic, isolate validation there before widening the rollout.

## See Also

- [Version Support](../reference/version-support.md)
- [Reliability](../best-practices/reliability.md)
- [Upgrade Failure](../troubleshooting/playbooks/operations/upgrade-failure.md)

## Sources

- [Create an AKS cluster](https://learn.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-cli)
- [Upgrade an AKS cluster](https://learn.microsoft.com/azure/aks/upgrade-cluster)
- [Monitor AKS with Container insights](https://learn.microsoft.com/azure/azure-monitor/containers/container-insights-overview)
- [Supported Kubernetes versions in AKS](https://learn.microsoft.com/azure/aks/supported-kubernetes-versions)
- [AKS release tracker](https://learn.microsoft.com/azure/aks/release-tracker)
