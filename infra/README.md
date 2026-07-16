# Shared Infrastructure Templates

Baseline scaffolding for shared Bicep / Terraform / Kubernetes templates that provision AKS clusters and supporting Azure resources.

## Status

**Authored.** This directory now contains deployable Bicep baselines for AKS public and private cluster variants, reusable infrastructure modules, and deployment scripts aligned to the production baseline pattern.

Current contents for the shared AKS baseline:

- **Authored**: `main.bicep`, `main-private.bicep`, `main.bicepparam`, `main-private.bicepparam`, `deploy.sh`, `deploy-private.sh`, and reusable module templates.
- **Scope**: Shared Azure infrastructure for the cluster baseline only. Kubernetes application manifests remain in `apps/`.

## What Belongs Here

This directory holds shared Bicep templates for a baseline AKS cluster (public and private variants), reusable modules (VNet, ACR, Key Vault, Log Analytics), and orchestration scripts. Templates in `infra/` are the *shared* infrastructure — per-lab infrastructure lives in `labs/<slug>/infra/` for scope isolation.

Suggested layout (mirrors the [Container Apps sibling repo](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/infra)):

```text
infra/
├── main.bicep                  # Public AKS baseline (VNet + AKS + Log Analytics + ACR)
├── main-private.bicep          # Private-cluster variant (Private Endpoint, Private DNS)
├── main.bicepparam             # Sample parameters for the public baseline
├── main-private.bicepparam     # Sample parameters for the private baseline
├── deploy.sh                   # Orchestration for main.bicep
├── deploy-private.sh           # Orchestration for main-private.bicep
└── modules/
    ├── network.bicep           # VNet, subnets, NSGs
    ├── acr-private.bicep       # ACR with Private Endpoint
    ├── keyvault-private.bicep  # Key Vault with optional Private Endpoint
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

The original P3 follow-up has now been executed on this branch:

- **P3-E — AKS shared infra authoring**: Completed with public and private AKS baselines, reusable modules, sample parameter files, and deployment scripts aligned with `docs/best-practices/production-baseline.md`.

## See Also

- [`../apps/README.md`](../apps/README.md) — Reference applications
- [`../labs/README.md`](../labs/README.md) — Lab companion assets
- [`../.sisyphus/plans/p2-aks-baseline-gap-map.md`](../.sisyphus/plans/p2-aks-baseline-gap-map.md) — Full P2-3 gap map
- [Container Apps `infra/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/infra) — Sibling reference model
