#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUTPUT_DIR="$SCRIPT_DIR/evidence/$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

kubectl get pods --namespace workload --selector app=ingress-lab --output wide > "$OUTPUT_DIR/pods.txt"
kubectl get service ingress-lab --namespace workload --output yaml > "$OUTPUT_DIR/service.yaml"
kubectl get endpoints ingress-lab --namespace workload --output yaml > "$OUTPUT_DIR/endpoints.yaml"
kubectl describe ingress ingress-lab --namespace workload > "$OUTPUT_DIR/ingress-describe.txt"
kubectl get events --namespace workload --sort-by=.lastTimestamp > "$OUTPUT_DIR/events.txt"

printf 'Evidence written to %s\n' "$OUTPUT_DIR"
