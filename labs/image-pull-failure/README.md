# Image Pull Failure Lab Companion

Runnable assets for [Fault Lab 01](../../docs/tutorials/lab-guides/fault-lab-01-image-pull-failure.md). This lab reuses the Python sample image from [`apps/python/`](../../apps/python/README.md) and assumes the cluster baseline already exists from [`infra/`](../../infra/README.md).

## Root Cause

The broken manifest points the deployment at a non-existent image tag so the pod fails before the container process can start.

## Scenarios

| Scenario | Manifest | Expected symptom |
|---|---|---|
| Broken | `workload/broken.yaml` | `ErrImagePull` or `ImagePullBackOff` |
| Fixed | `workload/fixed.yaml` | Pod reaches `Running` and `Ready` |

## Quick Start

1. Export `IMAGE_REPOSITORY` to a real image built from `apps/python/`.
2. Run `./trigger-scenario.sh`.
3. Run `./verify.sh` and preserve the generated evidence.
4. Run `./trigger-fix.sh`.
5. Run `./verify.sh` again and compare the before/after artifacts.

## Success Criteria

- Broken run shows pull failures tied to the image reference.
- Fixed run starts the pod without changing probes, service, or ingress.
- Evidence supports the falsification step in the reader-facing lab.

## Operator Takeaway

Capture image and event evidence before restarting anything. If a valid image still fails, pivot away from image lookup and toward registry auth or network reachability.
