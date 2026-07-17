# Pending Pods Resources Lab Companion

Runnable assets for [Fault Lab 03](../../docs/tutorials/lab-guides/fault-lab-03-pending-pods-resources.md). The manifests reuse the Python sample image from [`apps/python/`](../../apps/python/README.md).

## Root Cause

The broken manifest asks for more CPU and memory than a normal AKS lab cluster can schedule.

## Scenarios

| Scenario | Manifest | Expected symptom |
|---|---|---|
| Broken | `workload/broken.yaml` | Pod stays `Pending` with scheduler capacity errors |
| Fixed | `workload/fixed.yaml` | Pod schedules and becomes ready |

## Quick Start

1. Export `IMAGE_REPOSITORY`.
2. Run `./trigger-scenario.sh`.
3. Run `./verify.sh` before changing requests.
4. Run `./trigger-fix.sh`.
5. Run `./verify.sh` again.

## Success Criteria

- Broken run preserves `FailedScheduling` evidence.
- Fixed run schedules without changing selectors or image.

## Operator Takeaway

Right-size requests only after you preserve scheduler evidence. Otherwise you lose the proof that capacity, not runtime logic, was the blocker.
