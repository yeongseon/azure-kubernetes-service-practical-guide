# Reference Applications

Baseline scaffolding for reference applications that demonstrate Azure Kubernetes Service (AKS) patterns.

## Status

**Empty.** No reference applications are authored in this directory yet. This README is P2-3 baseline scaffolding — the directory establishes the shape but does not commit any application code.

Per P2-3 non-goals (issue [#24](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/issues/24)):

- **Not authored in P2**: reference application code, Dockerfiles, Kubernetes manifests.
- **Deferred to P3-D**: language-specific reference apps that demonstrate one AKS pattern each.

## What Belongs Here

When P3-D is executed, each subdirectory under `apps/` will contain one language-specific reference application that demonstrates a canonical AKS pattern (workload identity, ingress with AGIC, secrets via CSI, HPA/KEDA, etc.). Reference apps are minimal — they exist to back the tutorials in `docs/tutorials/lab-guides/`, not to be full production examples.

Suggested layout (mirrors the [Container Apps sibling repo](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/apps)):

```text
apps/
├── python/                     # Flask or FastAPI demonstrating one AKS pattern
│   ├── Dockerfile
│   ├── manifests/              # Kubernetes YAML (Deployment, Service, Ingress)
│   ├── src/
│   └── README.md
├── nodejs/                     # Express demonstrating one AKS pattern
│   ├── Dockerfile
│   ├── manifests/
│   └── ...
└── ...
```

Every reference app SHOULD include: a `Dockerfile`, a `manifests/` subdirectory with the Kubernetes objects needed for the pattern, a `README.md` explaining the pattern and how to deploy it, and any runtime files required (`requirements.txt`, `package.json`, etc.).

## Contract Reference

This directory participates in the **Phase 2f Series Lab Contract** (frozen spec: [`phase-2f-series-lab-contract.md`](https://github.com/yeongseon/azure-container-apps-practical-guide/blob/main/.sisyphus/plans/phase-2f-series-lab-contract.md)). Adopting the contract does NOT require authoring reference applications; it standardizes the shape *if and when* AKS authors them.

## Sibling Reference

The Container Apps sibling repository ships four reference applications under [`apps/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/apps): Python (Flask + Gunicorn), Node.js (Express), Java (Spring Boot), .NET (ASP.NET Core). AKS reference apps should follow the same one-language-per-directory convention but with Kubernetes manifests instead of Container Apps CLI/YAML.

## Follow-up

Content authoring is tracked as a named P3 follow-up:

- **P3-D — AKS reference-app authoring** (unassigned, not yet opened as an issue): Author minimal Python/Node.js reference applications that back the tutorials in `docs/tutorials/lab-guides/`. Should include workload identity and Key Vault CSI patterns to align with `lab-03-azure-key-vault-csi-driver.md`.

## See Also

- [`../infra/README.md`](../infra/README.md) — Shared infrastructure templates for AKS
- [`../labs/README.md`](../labs/README.md) — Lab companion assets
- [`../.sisyphus/plans/p2-aks-baseline-gap-map.md`](../.sisyphus/plans/p2-aks-baseline-gap-map.md) — Full P2-3 gap map
- [Container Apps `apps/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/apps) — Sibling reference model
