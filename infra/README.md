# Shared Infrastructure Templates

Baseline scaffolding for shared Bicep / Terraform / Kubernetes templates that provision AKS clusters and supporting Azure resources.

## Status

**Empty.** No infrastructure templates are authored in this directory yet. This README is P2-3 baseline scaffolding — the directory establishes the shape but does not commit any provisioning code.

Per P2-3 non-goals (issue [#24](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/issues/24)):

- **Not authored in P2**: `main.bicep`, `main-private.bicep`, deploy scripts, module templates.
- **Deferred to P3-E**: AKS-cluster provisioning templates aligned with the tutorials.

## What Belongs Here

When P3-E is executed, this directory will hold shared Bicep templates for a baseline AKS cluster (public and private variants), reusable modules (VNet, ACR, Key Vault, Log Analytics), and orchestration scripts. Templates in `infra/` are the *shared* infrastructure — per-lab infrastructure lives in `labs/<slug>/infra/` for scope isolation.

Suggested layout (mirrors the [Container Apps sibling repo](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/infra)):

```text
infra/
├── main.bicep                  # Public AKS baseline (VNet + AKS + Log Analytics + ACR)
├── main-private.bicep          # Private-cluster variant (Private Endpoint, Private DNS)
├── main-private.json           # Compiled ARM (kept in sync with Bicep for portability)
├── deploy.sh                   # Orchestration for main.bicep
├── deploy-private.sh           # Orchestration for main-private.bicep
└── modules/
    ├── network.bicep           # VNet, subnets, NSGs
    ├── acr-private.bicep       # ACR with Private Endpoint
    ├── keyvault-private.bicep  # Key Vault with Private Endpoint
    └── monitoring.bicep        # Log Analytics + Container Insights
```

## Kubernetes-Specific Notes

Unlike Azure Container Apps (which provisions the workload directly through Bicep), AKS separates cluster provisioning (Bicep) from workload deployment (Kubernetes YAML). This directory holds **Bicep for the cluster and its supporting Azure resources only**. Workload manifests (Deployments, Services, Ingress, HPA, etc.) live with the reference application in `apps/<language>/manifests/`.

## Not Applicable

Some Container Apps sibling directories do not apply to AKS:

- **`jobs/`** — Container Apps has a first-class **Jobs** resource type (scheduled/manual/event-driven serverless jobs). AKS uses in-cluster Kubernetes `CronJob` resources for the equivalent pattern, so `jobs/` at the repo root is not adopted. Kubernetes `CronJob` samples belong under `apps/<language>/manifests/` alongside the reference application.

## Contract Reference

This directory participates in the **Phase 2f Series Lab Contract** (frozen spec: [`phase-2f-series-lab-contract.md`](https://github.com/yeongseon/azure-container-apps-practical-guide/blob/main/.sisyphus/plans/phase-2f-series-lab-contract.md)). Adopting the contract does NOT require authoring infrastructure templates; it standardizes the shape *if and when* AKS authors them.

## Sibling Reference

The Container Apps sibling repository ships public and private Bicep baselines plus four reusable module templates under [`infra/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/infra). AKS shared infra should follow the same public/private split but with AKS-specific modules (private DNS for the API server, Azure CNI Overlay VNet layout, Azure Policy add-on).

## Follow-up

Content authoring is tracked as a named P3 follow-up:

- **P3-E — AKS shared infra authoring** (unassigned, not yet opened as an issue): Author `main.bicep` (public baseline: VNet + AKS + Log Analytics + ACR), `main-private.bicep` (private cluster with Private Endpoint on the API server), and reusable modules. Align with the "production baseline" pattern already documented in `docs/best-practices/production-baseline.md`.

## See Also

- [`../apps/README.md`](../apps/README.md) — Reference applications
- [`../labs/README.md`](../labs/README.md) — Lab companion assets
- [`../.sisyphus/plans/p2-aks-baseline-gap-map.md`](../.sisyphus/plans/p2-aks-baseline-gap-map.md) — Full P2-3 gap map
- [Container Apps `infra/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/infra) — Sibling reference model
