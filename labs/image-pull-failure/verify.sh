#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUTPUT_DIR="$SCRIPT_DIR/evidence/$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

kubectl get deployment image-pull-lab --namespace workload --output yaml > "$OUTPUT_DIR/deployment.yaml"
kubectl get pods --namespace workload --selector app=image-pull-lab --output wide > "$OUTPUT_DIR/pods.txt"
kubectl describe pod --namespace workload "$(kubectl get pod --namespace workload --selector app=image-pull-lab --output jsonpath='{.items[0].metadata.name}')" > "$OUTPUT_DIR/pod-describe.txt"
kubectl get events --namespace workload --sort-by=.lastTimestamp > "$OUTPUT_DIR/events.txt"

printf 'Evidence written to %s\n' "$OUTPUT_DIR"
