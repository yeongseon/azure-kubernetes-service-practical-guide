---
content_sources:
  diagrams:
  - id: tutorials-lab-guides-lab-05-aks-disaster-recovery
    type: flowchart
    source: mslearn-adapted
    mslearn_url: https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli
    based_on:
    - https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli
    - https://learn.microsoft.com/en-us/azure/aks/concepts-network
    - https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver
    - https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-for-kubernetes
    - https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview
---



# Tutorial 05: AKS Disaster Recovery

This tutorial simulates AKS disaster recovery planning by backing up cluster configuration, validating cross-region image and secret readiness, and rehearsing failover to a secondary cluster.

## Prerequisites

- Azure subscription with permission to create AKS, networking, and monitoring resources
- Azure CLI, `kubectl`, and a shell environment capable of exporting variables
- Existing or planned variable set for `$RG`, `$CLUSTER_NAME`, `$LOCATION`, and any lab-specific names
- A Log Analytics workspace resource ID stored in `$WORKSPACE_ID` for Container Insights validation
- Awareness that all commands use long flags only so they are easy to read and automate later

## Architecture Diagram

<!-- diagram-id: tutorials-lab-guides-lab-05-aks-disaster-recovery -->
```mermaid
flowchart TD
    subgraph Primary Region
        PRIMARY[Primary AKS cluster]
        ACR[Container registry]
        KV[Key Vault]
    end
    PRIMARY --> BACKUP[Backup manifests]
    BACKUP --> SECONDARY[Secondary AKS cluster]
    ACR --> SECONDARY
    KV --> SECONDARY
    SECONDARY --> MON[Failover validation and monitoring]
```

## Step-by-Step Instructions

### Step 1: Deploy a secondary resource group and cluster

```bash
az group create \
    --name "$DR_RG" \
    --location "$DR_LOCATION"

az aks create \
    --resource-group "$DR_RG" \
    --name "$DR_CLUSTER_NAME" \
    --location "$DR_LOCATION" \
    --network-plugin azure \
    --network-plugin-mode overlay \
    --nodepool-name system \
    --node-count 3 \
    --enable-managed-identity \
    --enable-aad \
    --enable-azure-rbac
```

| Command | Purpose |
| --- | --- |
| `az group create` | Create the disaster recovery resource group. |
| `--name` | Name of the resource group. |
| `--location` | Azure region for the resource group. |
| `az aks create` | Create the disaster recovery AKS cluster. |
| `--resource-group` | Resource group that contains the AKS cluster. |
| `--name` | Name of the AKS cluster. |
| `--location` | Azure region for the cluster. |
| `--network-plugin` | Container networking plugin. |
| `--network-plugin-mode` | Network plugin mode such as overlay. |
| `--nodepool-name` | Name of the initial system node pool. |
| `--node-count` | Number of nodes in the system pool. |
| `--enable-managed-identity` | Use a managed identity instead of a service principal. |
| `--enable-aad` | Enable Microsoft Entra integration. |
| `--enable-azure-rbac` | Use Azure RBAC for Kubernetes authorization. |

This step is important because it establishes the control point for **deploy a secondary resource group and cluster**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

### Step 2: Export manifests and backup cluster objects

```bash
kubectl get namespace \
    --output yaml > namespaces-backup.yaml

kubectl get deployment \
    --all-namespaces \
    --output yaml > deployments-backup.yaml

kubectl get ingress \
    --all-namespaces \
    --output yaml > ingress-backup.yaml
```

This step is important because it establishes the control point for **export manifests and backup cluster objects**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

### Step 3: Replicate container images and secret references

```bash
az acr import \
    --name "$DR_ACR_NAME" \
    --source "$PRIMARY_ACR_LOGIN_SERVER/app:v1" \
    --image app:v1

az keyvault secret backup \
    --vault-name "$KEYVAULT_NAME" \
    --name app-secret \
    --file app-secret-backup.bin
```

| Command | Purpose |
| --- | --- |
| `az acr import` | Import the application image into the DR registry. |
| `--name` | Name of the destination container registry. |
| `--source` | Source image reference to import. |
| `--image` | Target image name and tag. |
| `az keyvault secret backup` | Back up a Key Vault secret to a file. |
| `--vault-name` | Key Vault that holds the secret. |
| `--name` | Name of the secret to back up. |
| `--file` | Output file for the secret backup. |

This step is important because it establishes the control point for **replicate container images and secret references**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

### Step 4: Restore workloads to the secondary cluster

```bash
az aks get-credentials \
    --resource-group "$DR_RG" \
    --name "$DR_CLUSTER_NAME" \
    --overwrite-existing

kubectl apply \
    --filename namespaces-backup.yaml

kubectl apply \
    --filename deployments-backup.yaml

kubectl apply \
    --filename ingress-backup.yaml
```

| Command | Purpose |
| --- | --- |
| `az aks get-credentials` | Merge DR cluster credentials into the kubeconfig. |
| `--resource-group` | Resource group that contains the AKS cluster. |
| `--name` | Name of the AKS cluster. |
| `--overwrite-existing` | Overwrite any existing kubeconfig entry for the cluster. |
| `kubectl apply` | Apply the restored manifests to the DR cluster. |

This step is important because it establishes the control point for **restore workloads to the secondary cluster**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

### Step 5: Validate failover and monitoring

```bash
kubectl get pods \
    --all-namespaces \
    --output wide

az monitor log-analytics query \
    --workspace "$WORKSPACE_ID" \
    --analytics-query "KubeNodeInventory | where TimeGenerated > ago(15m) | summarize Nodes=dcount(Computer) by ClusterName" \
    --timespan "PT15M"
```

| Command | Purpose |
| --- | --- |
| `kubectl get pods` | List pods across namespaces. |
| `az monitor log-analytics query` | Query node inventory counts by cluster. |
| `--workspace` | Log Analytics workspace to query. |
| `--analytics-query` | KQL query text to execute. |
| `--timespan` | Time range for the query. |

This step is important because it establishes the control point for **validate failover and monitoring**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

## Validation Steps

Use the following validation flow after the deployment steps complete:

- Confirm the AKS cluster and all required node pools are visible with `kubectl get nodes --output wide`.
- Confirm the Azure resource provisioning state is `Succeeded` for any new network, gateway, identity, or policy resource.
- Run at least one Container Insights query to prove telemetry is flowing before you declare the lab complete.
- Capture screenshots or exported JSON only after sanitizing identifiers such as subscription IDs or object IDs.

Example validation commands:

```bash
kubectl get pods \
    --all-namespaces \
    --output wide
```

```bash
az aks show \
    --resource-group "$RG" \
    --name "$CLUSTER_NAME" \
    --query "{name:name,provisioningState:provisioningState,kubernetesVersion:kubernetesVersion}" \
    --output json
```

| Command | Purpose |
| --- | --- |
| `az aks show` | Show core cluster properties. |
| `--resource-group` | Resource group that contains the AKS cluster. |
| `--name` | Name of the AKS cluster. |
| `--query` | Selects name, provisioning state, and version. |
| `--output` | Output format for the result. |

```bash
az monitor log-analytics query \
    --workspace "$WORKSPACE_ID" \
    --analytics-query "KubeNodeInventory | where TimeGenerated > ago(15m) | summarize Nodes=dcount(Computer) by ClusterName" \
    --timespan "PT15M"
```

| Command | Purpose |
| --- | --- |
| `az monitor log-analytics query` | Query node inventory counts by cluster. |
| `--workspace` | Log Analytics workspace to query. |
| `--analytics-query` | KQL query text to execute. |
| `--timespan` | Time range for the query. |

## Cleanup Instructions

Delete lab resources when you are finished to avoid unnecessary spend. If the lab created shared resources that other exercises still need, remove only the lab-specific objects first.

```bash
az group delete \
    --name "$RG" \
    --yes \
    --no-wait
```

| Command | Purpose |
| --- | --- |
| `az group delete` | Delete the lab resource group and its resources. |
| `--name` | Name of the resource group to delete. |
| `--yes` | Skip the confirmation prompt. |
| `--no-wait` | Return without waiting for deletion to finish. |

If you created secondary resource groups, Application Gateway, or user-assigned identities, delete those resources as part of the same cleanup workflow or document why they remain.

## See Also

- [Reliability](../../best-practices/reliability.md)
- [Upgrades](../../operations/upgrades.md)
- [Cluster Resource and PV Backup](../../operations/cluster-resource-pv-backup.md)
- [Restore Drills](../../operations/restore-drills.md)

## Sources

- [Quickstart: Deploy an AKS cluster by using the Azure CLI](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli)
- [Network concepts for AKS](https://learn.microsoft.com/en-us/azure/aks/concepts-network)
- [Use the Azure Key Vault provider for Secrets Store CSI Driver in AKS](https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver)
- [Azure Policy for Kubernetes](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-for-kubernetes)
- [Container insights overview](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview)
