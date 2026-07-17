#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

RG="${RG:-rg-aks-baseline-demo}"
LOCATION="${LOCATION:-koreacentral}"
CLUSTER_NAME="${CLUSTER_NAME:-aks-baseline-demo}"
DNS_PREFIX="${DNS_PREFIX:-aksbaselinedemo}"
VNET_NAME="${VNET_NAME:-vnet-${CLUSTER_NAME}}"
AKS_SUBNET_NAME="${AKS_SUBNET_NAME:-snet-aks}"
WORKSPACE_NAME="${WORKSPACE_NAME:-log-${CLUSTER_NAME}}"
ACR_NAME="${ACR_NAME:-aksbaselinedemoacr}"
KEY_VAULT_NAME="${KEY_VAULT_NAME:-kv-aks-baseline-demo}"
DEPLOYMENT_NAME="${DEPLOYMENT_NAME:-aks-baseline-public}"

az account show --output none

az group create \
    --name "$RG" \
    --location "$LOCATION" \
    --output none

az deployment group create \
    --resource-group "$RG" \
    --name "$DEPLOYMENT_NAME" \
    --template-file "$SCRIPT_DIR/main.bicep" \
    --parameters "$SCRIPT_DIR/main.bicepparam" \
    --parameters \
        clusterName="$CLUSTER_NAME" \
        location="$LOCATION" \
        dnsPrefix="$DNS_PREFIX" \
        vnetName="$VNET_NAME" \
        aksSubnetName="$AKS_SUBNET_NAME" \
        logAnalyticsWorkspaceName="$WORKSPACE_NAME" \
        acrName="$ACR_NAME" \
        keyVaultName="$KEY_VAULT_NAME" \
    --query properties.outputs \
    --output json
