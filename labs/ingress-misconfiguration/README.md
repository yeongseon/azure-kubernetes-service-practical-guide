# Ingress Misconfiguration Lab Companion

Runnable assets for [Fault Lab 04](../../docs/tutorials/lab-guides/fault-lab-04-ingress-misconfiguration.md). The manifests reuse the Python sample image from [`apps/python/`](../../apps/python/README.md) and model a routing failure at the ingress layer.

## Root Cause

The broken manifest points the ingress backend to service port `8080` even though the service only exposes port `80`.

## Scenarios

| Scenario | Manifest | Expected symptom |
|---|---|---|
| Broken | `workload/broken.yaml` | Ingress exists but backend routing is incorrect |
| Fixed | `workload/fixed.yaml` | Ingress routes to healthy endpoints |

## Quick Start

1. Export `IMAGE_REPOSITORY`.
2. Export `APP_HOSTNAME` to a hostname routed to the cluster ingress controller.
3. Run `./trigger-scenario.sh`.
4. Run `./verify.sh`.
5. Run `./trigger-fix.sh` and verify again.

## Success Criteria

- Broken run shows healthy pods and endpoints with a bad ingress backend.
- Fixed run restores routing without rebuilding the app.

## Operator Takeaway

Healthy pods do not prove healthy ingress. Preserve ingress, service, and endpoint evidence together before remediation.
