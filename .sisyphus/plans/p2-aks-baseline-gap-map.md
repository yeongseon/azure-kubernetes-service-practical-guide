# P2-3 Baseline Gap Map — Azure Kubernetes Service Practical Guide

**Status**: DRAFT — Scaffolding shipped, gap-map complete, no content authored. P3 follow-ups proposed.
**Scope**: azure-kubernetes-service-practical-guide repository. Root-level `apps/`, `infra/`, `labs/` scaffolding + existing lab-guide taxonomy assessment.
**Non-goals**: Authoring new labs or reference applications, full content expansion, migrating existing docs pages, work in other repos.
**Author**: Sisyphus (agent)
**Related issue**: [azure-kubernetes-service-practical-guide#24](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/issues/24)
**Parent tracker**: [azure-architecture-practical-guide#34](https://github.com/yeongseon/azure-architecture-practical-guide/issues/34) (Phase 2 meta-tracker)
**Predecessor audits**:

- P2-1 (frontmatter provenance): [`p2-frontmatter-audit.md`](https://github.com/yeongseon/azure-architecture-practical-guide/blob/main/.sisyphus/plans/p2-frontmatter-audit.md) — AKS already 100% canonical (69/69 pages).
- P2-2 (existing-lab compliance): [`p2-existing-lab-audit.md`](https://github.com/yeongseon/azure-architecture-practical-guide/blob/main/.sisyphus/plans/p2-existing-lab-audit.md) — AKS 5 lab guides are tutorial-style, not Variant A.

**Contract source**: [`phase-2f-series-lab-contract.md`](https://github.com/yeongseon/azure-container-apps-practical-guide/blob/main/.sisyphus/plans/phase-2f-series-lab-contract.md) §3-8.

---

## 1. Executive Summary

Azure Container Apps is the reference model for the series-wide repo shape: it ships `apps/`, `infra/`, `labs/`, and `jobs/` at the repo root, alongside `docs/` and `scripts/`. The AKS repo currently ships only `docs/`, `scripts/`, and `site/` (the last is `mkdocs build` output). No `apps/`, `infra/`, or `labs/` directories existed at the repo root before P2-3.

This audit establishes the baseline scaffolding: three empty directories (`apps/`, `infra/`, `labs/`) plus a README in each that documents the intended contract, the sibling reference model, and the named P3 follow-ups for content authoring. It also records a fourth deliverable — this gap-map document — and one deliberate exclusion (`jobs/` is not adopted, because AKS uses in-cluster Kubernetes `CronJob` resources rather than a standalone Azure Jobs resource).

**Three P3 follow-ups are proposed for content authoring** (not executed here, per P2-3 non-goals):

- **P3-C** (from P2-2 audit) — Reclassify the 5 existing AKS lab guides in `docs/tutorials/lab-guides/` as tutorials rather than labs. Estimated 4-8 hours.
- **P3-D** — Author minimal reference applications under `apps/{python,nodejs}/`. Deferred.
- **P3-E** — Author shared cluster-provisioning Bicep under `infra/`. Deferred.

**One optional P3 follow-up** is registered for future consideration:

- **P3-F** — Author AKS Variant A experimental labs (CNI IP exhaustion, HPA metric-server unavailable, ingress-not-working, node-not-ready). Deferred; optional.

The AKS repo is Phase 2f-compliant regardless of whether P3-D/E/F execute — Phase 2f §1 states explicitly that adopting the contract does NOT require authoring a lab. What matters at P2-3 exit is that the scaffolding shape now exists and future authoring is bound to the contract.

## 2. Methodology

### 2.1 Reference model

The Azure Container Apps sibling repository was used as the reference for the target root-level shape. That repo's structure, confirmed by `ls` on `main` at the time of this audit:

```text
apps/{dotnet-aspnetcore, java-springboot, nodejs, python}/
infra/{main.bicep, main-private.bicep, main-private.json,
       deploy.sh, deploy-private.sh, modules/{acr-private, keyvault-private, network, storage-private}.bicep}
labs/<slug>/ × 29
jobs/python/
docs/
scripts/
```

### 2.2 Current-state inspection

The AKS repo's `main` at the time of this audit was `e968c2b` (`docs(scenario-router): add unified scenario-router.md`). Directory tree at repo root:

```text
.github/, .sisyphus/, docs/, scripts/, site/
AGENTS.md, README.md, README.ko.md, README.ja.md, README.zh-CN.md
LICENSE, mkdocs.yml, requirements-docs.txt, CODE_OF_CONDUCT.md, SECURITY.md
```

No `apps/`, `infra/`, `labs/`, or `jobs/` directories existed at the repo root. `docs/tutorials/lab-guides/` contained 5 tutorial-style lab guides (see P2-2 audit for structural analysis).

`AGENTS.md` §"Repository Structure" (lines 46-63) declared only `.github/`, `docs/`, and `mkdocs.yml`. P2-3 adds scaffolding but does not modify `AGENTS.md` — that is deferred to whichever P3 issue lands the first content in `apps/`, `infra/`, or `labs/`, so `AGENTS.md` is updated in the same commit as the first substantive content.

### 2.3 Deliverables

Per issue [#24](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/issues/24):

- Establish baseline structure: `apps/`, `infra/`, `labs/` at repo root — **DONE**.
- Per-directory README explaining the contract — **DONE** ([apps](../../apps/README.md), [infra](../../infra/README.md), [labs](../../labs/README.md)).
- Link existing lab guides to companion assets where they exist — **N/A**: no companion assets exist yet; the labs/README documents the intended link direction for future assets.
- Explicitly document N/A subdirectories with rationale — **DONE**: `jobs/` documented as N/A in [infra/README.md](../../infra/README.md#not-applicable) with rationale.
- Split larger content-authoring work into named follow-up P3 issues — **DONE** (see §5 below).
- Deliverable: merged baseline scaffolding + gap-map document — **DONE** (this file + 3 READMEs).

## 3. Current State vs Reference Model

| Directory | AKS current | CA reference | Gap | Action in P2-3 | Follow-up |
|---|---|---|---|---|---|
| `apps/` | Missing | 4 language apps (Python, Node.js, Java, .NET) | Present | Create dir + README | P3-D |
| `infra/` | Missing | main.bicep + main-private.bicep + 4 modules + 2 deploy scripts | Present | Create dir + README | P3-E |
| `labs/` | Missing | 29 lab companion dirs | Present | Create dir + README | P3-F (optional) |
| `jobs/` | Missing | 1 job type (python) | N/A — Kubernetes `CronJob` in-cluster replaces this | **Not adopted**, rationale in infra/README.md | none |
| `docs/tutorials/lab-guides/` | 5 tutorial-style guides | ~55 Variant A guides in `docs/troubleshooting/lab-guides/` | Wrong taxonomy — labs are actually tutorials | Documented in labs/README.md | P3-C |
| `docs/`, `scripts/`, `site/` | Present | Present | None | none | none |

## 4. Existing-Content Assessment

### 4.1 Existing lab guides — tutorial-style, not Variant A

Per P2-2 audit, all 5 lab guides under `docs/tutorials/lab-guides/` structurally match the AGENTS.md **Language Guides / Tutorials** taxonomy, not Phase 2f Variant A experimental labs. Recap of the P2-2 finding:

- All 5 use `## Prerequisites` + `## Architecture Diagram` + `## Step-by-Step Instructions` + `### Step 1-N` + `## Validation Steps` + `## Cleanup Instructions`.
- 0/5 contain a hypothesis, prediction, or falsification-after-fix.
- 0/5 have a paired symptom-based playbook.
- 0/5 have a companion `labs/<slug>/` directory.

The P2-2 audit recommends **reclassification** (rename in nav + intros) rather than **upgrade** (force experimental framing onto tutorial content). This is tracked as P3-C below.

### 4.2 Reference application code — does not exist

There are no reference applications under any path in the AKS repo. The tutorial guides in `docs/tutorials/lab-guides/` reference `kubectl` commands and Kubernetes manifests inline but do not link to any application source. This is not a regression — the tutorials are self-contained. Reference apps under `apps/` are additive and optional.

### 4.3 Shared infrastructure templates — do not exist

There are no Bicep, Terraform, or shared Kubernetes manifest files at the repo root or under any path outside `docs/`. The tutorial in `lab-01-aks-cluster-deployment.md` provides inline `az aks create` commands but does not link to any reusable template. This is not a regression — the tutorials are self-contained. Shared infra under `infra/` is additive and optional.

### 4.4 Frontmatter provenance — already canonical

Per P2-1 audit, all 69 pages under `docs/` in the AKS repo use the canonical `content_sources.diagrams[...]` shape. No frontmatter work is required in P2-3.

## 5. Named P3 Follow-ups

The following P3 items are proposed as follow-ups. Each is a named backlog item; none are opened as GitHub issues in P2-3 (that step may be actioned in the P2 wave closeout on the meta-tracker).

### P3-C — Reclassify existing AKS lab guides as tutorials

- **Repo**: azure-kubernetes-service-practical-guide
- **Type**: Reclassification, no content rewrite
- **Effort**: ~4-8 hours
- **Rationale**: Existing 5 lab guides are structurally tutorials, not Variant A experiments. Phase 2f Variant A requires hypothesis + falsification; forcing that framing would misrepresent the artifact (Phase 2f §5 explicitly forbids substituting cross-variant elements).
- **Deliverables**:
    - Rename the 5 files: consider `docs/tutorials/lab-guides/lab-NN-*.md` → `docs/tutorials/lab-NN-*.md` (drop the "lab-guides/" subpath) or keep the path and drop the "Lab" framing in titles and intros.
    - Update `mkdocs.yml` nav to say "Tutorials" not "Labs".
    - Update page intros from "This lab walks through..." to "This tutorial walks through...".
    - Do NOT modify content, procedure, or code samples.
- **Blocker**: None. Independent of other P3 items.
- **Success criteria**: Nav says "Tutorials", pages say "Tutorial" not "Lab", link-check clean, no other content changes.

### P3-D — Author reference applications for AKS

- **Repo**: azure-kubernetes-service-practical-guide
- **Type**: New content authoring
- **Effort**: ~8-16 hours per language (2 languages minimum recommended)
- **Rationale**: Reference applications back the tutorials with runnable code. Container Apps sibling has 4 languages; AKS should start with 2 (Python + Node.js) to cover the two most common tutorial code samples.
- **Deliverables**:
    - `apps/python/` — Flask or FastAPI + Dockerfile + Kubernetes manifests (Deployment, Service, Ingress, HPA) demonstrating one AKS pattern (recommendation: workload identity + Key Vault CSI, aligning with `lab-03`).
    - `apps/nodejs/` — Express + Dockerfile + Kubernetes manifests demonstrating one AKS pattern (recommendation: AGIC ingress, aligning with `lab-02`).
    - README in each subdirectory explaining the pattern and deploy steps.
- **Blocker**: None. Can proceed independently of P3-E, though co-locating a deploy path with P3-E's Bicep would be ideal.
- **Success criteria**: `kubectl apply -f apps/python/manifests/` succeeds against an AKS cluster provisioned by `az aks create` (or P3-E's Bicep if landed first); app returns HTTP 200 on a simple endpoint.

### P3-E — Author shared AKS infrastructure Bicep

- **Repo**: azure-kubernetes-service-practical-guide
- **Type**: New content authoring
- **Effort**: ~8-16 hours for `main.bicep` public baseline; +4-8 hours for `main-private.bicep`
- **Rationale**: Shared Bicep provides a reproducible cluster baseline that tutorials, reference apps, and future Variant A labs can build on. Container Apps sibling has both public and private variants.
- **Deliverables**:
    - `infra/main.bicep` — Public baseline: VNet + AKS (Azure CNI Overlay, Workload Identity enabled, Container Insights add-on) + Log Analytics + ACR.
    - `infra/main-private.bicep` — Private-cluster variant: AKS with private API server, Private DNS Zone for `privatelink.<region>.azmk8s.io`, Private Endpoint on ACR.
    - `infra/modules/` — Reusable modules for network, ACR, Key Vault, monitoring.
    - `infra/deploy.sh` and `infra/deploy-private.sh` — Orchestration scripts.
- **Blocker**: None. Can proceed in parallel with P3-D.
- **Success criteria**: `az deployment sub create --template-file infra/main.bicep` provisions a working AKS cluster in <20 minutes; `kubectl get nodes` returns Ready nodes.

### P3-F — Author AKS Variant A experimental labs (optional)

- **Repo**: azure-kubernetes-service-practical-guide
- **Type**: New content authoring
- **Effort**: ~8-16 hours per lab (4 candidate labs)
- **Rationale**: OPTIONAL — Phase 2f explicitly does not require any lab authoring. Registered here so the option is discoverable if AKS decides to add reproduction-style labs later.
- **Candidate labs**:
    - CNI IP exhaustion (Azure CNI Overlay pod IP pool exhaustion → pod scheduling failures)
    - HPA metric-server unavailable (`kubectl top` failures → HPA scaling stops)
    - Ingress-not-working (AGIC misconfiguration → 502/503)
    - Node-not-ready (kubelet unreachable → workload eviction)
- **Deliverables** (per lab):
    - `labs/<slug>/README.md` — Root Cause + Scenarios table + Quick Start + Success + Takeaway.
    - `labs/<slug>/infra/main.bicep` — RG-scoped Bicep for this lab only.
    - `labs/<slug>/workload/` — Kubernetes manifests + Dockerfile + app source.
    - `labs/<slug>/evidence/` — Captured Azure Monitor + kubectl output.
    - `labs/<slug>/trigger-*.sh`, `verify.sh`, `cleanup.sh`.
    - Reader-facing lab guide under `docs/troubleshooting/lab-guides/<slug>.md` (this section does not exist yet; would be created).
    - Paired playbook under `docs/troubleshooting/playbooks/<slug>.md` (this taxonomy already exists).
- **Blocker**: P3-E recommended as prerequisite (labs need shared cluster infra).
- **Success criteria**: Each lab reproduces the failure deterministically, provides a working fix, and includes falsification-after-fix per Phase 2f A2.

## 6. Non-Goals Honored

Per issue [#24](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/issues/24):

- ✅ **Not authoring new labs or reference applications inside P2**: Directories are empty; only READMEs and this gap-map exist.
- ✅ **Not doing full content expansion of apps/, infra/, labs/**: No `.bicep`, no `Dockerfile`, no `.py`, no `.yaml` workload manifests, no `.sh` scripts added.
- ✅ **Not migrating existing docs pages to new structure**: The 5 existing lab guides in `docs/tutorials/lab-guides/` are unchanged in P2-3. Their reclassification is deferred to P3-C.
- ✅ **Not touching anything outside AKS repo**: Only files added are `apps/README.md`, `infra/README.md`, `labs/README.md`, and this gap-map.

## 7. Summary Table

| Deliverable | Status | Location |
|---|---|---|
| `apps/` directory | ✅ Created (empty) | `apps/` |
| `apps/README.md` | ✅ Authored | [`apps/README.md`](../../apps/README.md) |
| `infra/` directory | ✅ Created (empty) | `infra/` |
| `infra/README.md` | ✅ Authored | [`infra/README.md`](../../infra/README.md) |
| `labs/` directory | ✅ Created (empty) | `labs/` |
| `labs/README.md` | ✅ Authored | [`labs/README.md`](../../labs/README.md) |
| Gap-map document | ✅ Authored | This file |
| `jobs/` — N/A rationale documented | ✅ | [infra/README.md#not-applicable](../../infra/README.md#not-applicable) |
| P3-C follow-up registered | ✅ | §5 above |
| P3-D follow-up registered | ✅ | §5 above |
| P3-E follow-up registered | ✅ | §5 above |
| P3-F follow-up registered (optional) | ✅ | §5 above |
| `AGENTS.md` update | ⏸ Deferred | Land with first content in `apps/`/`infra/`/`labs/` |

## 8. Next Steps

1. **Commit + push P2-3 scaffolding**: Explicit `git add` of only these 4 files. Do NOT stage the pre-existing dirty `site/*.html` build artifacts.
2. **Close issue [#24](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/issues/24)** with P2-3 completion comment linking to this gap-map and the 3 READMEs.
3. **Update Phase 2 meta-tracker** [azure-architecture-practical-guide#34](https://github.com/yeongseon/azure-architecture-practical-guide/issues/34) with P2-3 completion + full P2 wave closeout (P2-1, P2-2, P2-3 all done).
4. **Optionally register P3-A/B/C follow-ups** as GitHub issues in their respective repos per prior user directive *"타당 하면 모두 이슈등록"* — pending user acknowledgment before opening P3-D/E/F, which are more speculative.

## See Also

- [`apps/README.md`](../../apps/README.md), [`infra/README.md`](../../infra/README.md), [`labs/README.md`](../../labs/README.md) — Scaffolding READMEs
- [P2-1 frontmatter audit](https://github.com/yeongseon/azure-architecture-practical-guide/blob/main/.sisyphus/plans/p2-frontmatter-audit.md)
- [P2-2 existing-lab audit](https://github.com/yeongseon/azure-architecture-practical-guide/blob/main/.sisyphus/plans/p2-existing-lab-audit.md)
- [Phase 2f Series Lab Contract](https://github.com/yeongseon/azure-container-apps-practical-guide/blob/main/.sisyphus/plans/phase-2f-series-lab-contract.md)
- [Phase 2 meta-tracker (issue #34)](https://github.com/yeongseon/azure-architecture-practical-guide/issues/34)
- [Container Apps sibling repo](https://github.com/yeongseon/azure-container-apps-practical-guide) — Reference model
