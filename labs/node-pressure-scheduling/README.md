# Node Pressure and Scheduling Lab Companion

Runnable assets for [Fault Lab 05](../../docs/tutorials/lab-guides/fault-lab-05-node-pressure-scheduling.md). The manifests reuse the Python sample image and focus on scheduler evidence, not live node repair.

## Root Cause

The broken manifest forces the workload onto the system node pool without the taint tolerance required for that pool, so scheduling fails even if nodes stay healthy.

## Scenarios

| Scenario | Manifest | Expected symptom |
|---|---|---|
| Broken | `workload/broken.yaml` | Pod remains `Pending` with taint or selector mismatch |
| Fixed | `workload/fixed.yaml` | Pod schedules normally |

## Quick Start

1. Export `IMAGE_REPOSITORY`.
2. Run `./trigger-scenario.sh`.
3. Run `./verify.sh` and preserve scheduler evidence.
4. Run `./trigger-fix.sh`.
5. Run `./verify.sh` again and compare node and pod state.

## Success Criteria

- Broken run preserves `FailedScheduling` evidence tied to placement rules.
- Fixed run schedules without changing the image.

## Operator Takeaway

Separate node-health incidents from placement mistakes. `Pending` plus ready nodes usually means scheduler policy, not a broken kubelet.
