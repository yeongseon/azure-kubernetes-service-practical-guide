#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl delete --filename "$SCRIPT_DIR/workload/fixed.yaml" --ignore-not-found=true
kubectl delete --filename "$SCRIPT_DIR/workload/broken.yaml" --ignore-not-found=true
kubectl delete --filename "$SCRIPT_DIR/workload/namespace.yaml" --ignore-not-found=true

if [[ "${DELETE_RESOURCE_GROUP:-false}" == "true" ]] && [[ -n "${RG:-}" ]]; then
    az group delete --name "$RG" --yes --no-wait
fi
