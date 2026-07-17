# CrashLoopBackOff Lab Companion

Runnable assets for [Fault Lab 02](../../docs/tutorials/lab-guides/fault-lab-02-crashloopbackoff.md). The assets reuse the Python sample image from [`apps/python/`](../../apps/python/README.md).

## Root Cause

The broken manifest overrides the container startup command so the process exits immediately with a non-zero status.

## Scenarios

| Scenario | Manifest | Expected symptom |
|---|---|---|
| Broken | `workload/broken.yaml` | `CrashLoopBackOff` with increasing restart count |
| Fixed | `workload/fixed.yaml` | Pod becomes stable and ready |

## Quick Start

1. Export `IMAGE_REPOSITORY` to the built sample app image.
2. Run `./trigger-scenario.sh`.
3. Run `./verify.sh` before any restart or reapply.
4. Run `./trigger-fix.sh`.
5. Run `./verify.sh` again to capture the falsification evidence.

## Success Criteria

- Broken run produces restart churn and previous-container evidence.
- Fixed run stabilizes without changing image, service, or scheduler placement.

## Operator Takeaway

Previous-container logs and exit codes are the fastest disproof tools for a crash-loop symptom.
