---
description: What the Azure Kubernetes Service Practical Guide continuous integration validates — docs, content sources, Bicep, Kubernetes manifests, the Python sample app, and the container build — and what it intentionally does not.
---

# CI Validation Scope

This repository ships runnable artifacts (a Python sample app under `apps/`, Bicep infrastructure under `infra/`, Kubernetes manifests, and reproducible labs under `labs/`) alongside the documentation. Continuous integration validates these artifacts on every pull request so guidance stays reproducible, while deliberately avoiding any check that would require live Azure credentials or incur cloud cost.

## Workflows

| Workflow | File | Trigger paths |
|---|---|---|
| Deploy Documentation | `.github/workflows/docs.yml` | `docs/**`, `mkdocs.yml` |
| Validate Content Source Metadata | `.github/workflows/validate-content-sources.yml` | `docs/**`, `scripts/**`, root markdown, `mkdocs.yml`, `.github/workflows/**` |
| Validate Artifacts | `.github/workflows/validate-artifacts.yml` | `apps/**`, `infra/**`, `labs/**` |

## What CI Validates

### Documentation

- `mkdocs build --strict` builds the full site and fails on broken internal links, missing nav entries, or unrecognized anchors.
- `validate_content_sources.py` enforces the canonical `content_sources.diagrams[…]` provenance shape on every Mermaid page.
- Microsoft Learn URL locale normalization (`/en-us/` prefix).
- Frontmatter YAML style drift.

### Infrastructure (Bicep)

The `bicep-build` job runs `az bicep build` against `infra/main.bicep`, `infra/main-private.bicep`, and every module under `infra/modules/`. This compiles the templates to ARM JSON and surfaces syntax and type errors without deploying anything.

### Kubernetes manifests

The `k8s-manifests` job validates every manifest under `apps/**/manifests/` and `labs/**/workload/`:

- YAML syntax parsing with PyYAML (multi-document aware).
- Schema validation with `kubeconform --ignore-missing-schemas`, which checks each resource against the upstream Kubernetes OpenAPI schemas.

### Python sample app

The `python-app` job installs `apps/python/requirements.txt`, byte-compiles the sources with `py_compile`, and runs `ruff check` (non-blocking) for lint feedback.

### Container image

The `container-build` job builds `apps/python/Dockerfile` with Docker Buildx (`push: false`) using a GitHub Actions build cache. This proves the image builds from a clean checkout without publishing it to any registry.

### Dockerfile lint

The `dockerfile-lint` job runs `hadolint` against `apps/python/Dockerfile` (non-blocking) for best-practice feedback.

## What CI Does Not Validate

CI is intentionally scoped to static and build-time checks. It does **not**:

- Deploy any resource to Azure or authenticate to a subscription.
- Provision an AKS cluster or apply manifests to a live cluster.
- Run `az deployment group create`, `terraform apply`, or `kubectl apply` against real infrastructure.
- Push container images to Azure Container Registry or any registry.
- Execute the fault-injection labs end-to-end (they require a live cluster and are validated manually; see the lab guides).

These exclusions keep pull-request CI fast, credential-free, and zero-cost. Live validation is performed manually and recorded in the [tutorial validation dashboard](../reference/validation-status.md).

## Adding a New Artifact

When you add a new runnable artifact, extend `validate-artifacts.yml` so it is covered:

- New manifests → place them under `apps/**/manifests/` or `labs/**/workload/` so the existing glob picks them up.
- New Bicep modules → they are auto-discovered under `infra/modules/`; a new top-level template needs an explicit `az bicep build --file` line.
- A new sample app → add a build/compile job mirroring `python-app` and `container-build`.

## See Also

- [Contributing](index.md)
- [Navigation IA Convention](navigation-ia.md)
- [Tutorial Validation Status](../reference/validation-status.md)
