# Lab Companion Assets

Baseline scaffolding for per-lab companion directories (`labs/<slug>/`) that carry Bicep templates, workload code, verify/cleanup scripts, and captured evidence for AKS labs.

## Status

**Empty.** No lab companion directories are authored yet. This README is P2-3 baseline scaffolding — the directory establishes the shape but does not commit any lab assets.

Per P2-3 non-goals (issue [#24](https://github.com/yeongseon/azure-kubernetes-service-practical-guide/issues/24)):

- **Not authored in P2**: per-lab `labs/<slug>/` directories with Bicep + workload + scripts + evidence.
- **Deferred to P3**: content authoring and (separately) the reclassification of existing tutorial-style lab guides.

## Existing Lab Guides

Five hands-on guides already exist under [`docs/tutorials/lab-guides/`](../docs/tutorials/lab-guides/):

- `lab-01-aks-cluster-deployment.md`
- `lab-02-application-gateway-ingress.md`
- `lab-03-azure-key-vault-csi-driver.md`
- `lab-04-azure-policy-for-aks.md`
- `lab-05-aks-disaster-recovery.md`

**These are tutorial-style walkthroughs, not Variant A experiments.** The P2-2 audit ([architecture#37](https://github.com/yeongseon/azure-architecture-practical-guide/issues/37); deliverable: [`p2-existing-lab-audit.md`](https://github.com/yeongseon/azure-architecture-practical-guide/blob/main/.sisyphus/plans/p2-existing-lab-audit.md)) found that all 5 use `## Prerequisites` + `## Architecture Diagram` + `## Step-by-Step Instructions` + `### Step 1-N` + `## Validation Steps` + `## Cleanup Instructions`. None contain a hypothesis, prediction, or falsification-after-fix step. They structurally match the [AGENTS.md **Language Guides / Tutorials**](../AGENTS.md#core-sections) taxonomy, not Phase 2f Variant A experimental labs.

The P2-2 audit recommends **reclassification** (Option 1 — rename these as tutorials in navigation and page intros) rather than **upgrade** (Option 2 — force experimental-lab framing onto content that is not experimental). Tracked as P3-C below.

## What Belongs Here

When Variant A experimental labs are authored, each lab gets a companion directory `labs/<slug>/` that carries the runnable artifacts backing the reader-facing lab guide in `docs/troubleshooting/lab-guides/` (note: `docs/tutorials/lab-guides/` is the current path used by the tutorial-style guides; Variant A labs would live under `docs/troubleshooting/lab-guides/` once that section is established).

Suggested layout (mirrors the [Container Apps sibling repo](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/labs)):

```text
labs/
└── <slug>/                     # e.g., cni-ip-exhaustion, pod-crashloopbackoff
    ├── README.md               # Root Cause + Scenarios table + Quick Start + Success + Takeaway
    ├── infra/main.bicep        # RG-scoped Bicep for THIS lab only
    ├── workload/               # Kubernetes manifests, app source, Dockerfile
    ├── evidence/               # Captured Azure Monitor / kubectl output
    ├── trigger-scenario-a.sh   # Reproduce failure scenario A
    ├── trigger-scenario-b.sh   # Reproduce failure scenario B (optional)
    ├── trigger-fix.sh          # Apply the fix
    ├── verify.sh               # Collect evidence
    └── cleanup.sh              # az group delete or equivalent
```

## Contract Reference

Per **Phase 2f Series Lab Contract** ([spec](https://github.com/yeongseon/azure-container-apps-practical-guide/blob/main/.sisyphus/plans/phase-2f-series-lab-contract.md)):

- **MUST tier** (§3): every lab document has a purpose, testable claim, procedure, evidence method, closing validation, and cleanup declaration.
- **Variant A SHOULD** (§4): reproduction labs SHOULD add A1 (hypothesis + prediction), A2 (falsification-after-fix), A3 (paired symptom-based playbook), A4 (companion `labs/<slug>/` directory — this directory), A5 (evidence-section variant).

Variant A companion directories live here. The MUST tier and remaining SHOULD elements live in the corresponding lab guide under `docs/troubleshooting/lab-guides/<slug>.md`.

## Sibling Reference

The Container Apps sibling repository ships 29 lab companion directories under [`labs/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/labs). Notable exemplars for the AKS scaffolding pattern:

- [`labs/memory-leak-oomkilled/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/labs/memory-leak-oomkilled) — full Variant A reference: 3 scenarios (hard/gradual/healthy), Bicep infra, workload code, verify/cleanup scripts, evidence capture, operator takeaway. AKS labs on pod-level failures (CrashLoopBackOff, OOMKilled) should mirror this shape.
- [`labs/probe-and-port-mismatch/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/labs/probe-and-port-mismatch) — small-scale Variant A: single trigger + fix + evidence. Suitable pattern for AKS labs targeting one symptom.

## Follow-up

Content authoring and reclassification are tracked as named P3 follow-ups:

- **P3-C — Reclassify existing AKS lab guides as tutorials** (from P2-2 audit, unassigned, not yet opened as an issue): Rename the 5 files in `docs/tutorials/lab-guides/` and their nav entries to remove the "lab" framing; adjust intros to say "Tutorial" instead of "Lab". Estimated 4-8 hours. Does NOT rewrite content — reclassification only.
- **P3-F — Author AKS Variant A experimental labs** (optional, unassigned, not yet opened as an issue): If AKS decides to add reproduction-style labs, author them under this directory using the memory-leak-oomkilled shape as the pattern. Candidates: CNI IP exhaustion, HPA metric-server unavailable, ingress-not-working, node-not-ready. Each lab requires a paired playbook in `docs/troubleshooting/playbooks/`. Estimated 8-16 hours per lab.

## See Also

- [`../apps/README.md`](../apps/README.md) — Reference applications
- [`../infra/README.md`](../infra/README.md) — Shared infrastructure templates
- [`../.sisyphus/plans/p2-aks-baseline-gap-map.md`](../.sisyphus/plans/p2-aks-baseline-gap-map.md) — Full P2-3 gap map
- [P2-2 audit — Existing-lab compliance state](https://github.com/yeongseon/azure-architecture-practical-guide/blob/main/.sisyphus/plans/p2-existing-lab-audit.md) — Full P2-2 findings for the 5 existing AKS lab guides
- [Container Apps `labs/`](https://github.com/yeongseon/azure-container-apps-practical-guide/tree/main/labs) — Sibling reference model
- [Phase 2f Series Lab Contract §4 — Variant A](https://github.com/yeongseon/azure-container-apps-practical-guide/blob/main/.sisyphus/plans/phase-2f-series-lab-contract.md#4-variant-a--reproduction-labs-should-for-repos-with-reproduction-labs)
