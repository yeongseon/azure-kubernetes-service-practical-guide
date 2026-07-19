---
content_sources:
  diagrams:
  - id: tutorials-lab-guides-lab-01-aks-cluster-deployment
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



# Tutorial 01: AKS Cluster Deployment

This tutorial walks through a production-oriented AKS deployment using a private cluster, Azure CNI Overlay, Microsoft Entra integration, and Container Insights. The goal is to create a repeatable cluster baseline rather than a throwaway demo.

## Prerequisites

- Azure subscription with permission to create AKS, networking, and monitoring resources
- Azure CLI, `kubectl`, and a shell environment capable of exporting variables
- Existing or planned variable set for `$RG`, `$CLUSTER_NAME`, `$LOCATION`, and any lab-specific names
- A Log Analytics workspace resource ID stored in `$WORKSPACE_ID` for Container Insights validation
- Awareness that all commands use long flags only so they are easy to read and automate later

## Architecture Diagram

<!-- diagram-id: tutorials-lab-guides-lab-01-aks-cluster-deployment -->
```mermaid
flowchart TD
    subgraph Azure Subscription
        ENTRA[Microsoft Entra ID]
        LA[Log Analytics Workspace]
        subgraph Virtual Network
            API[Private AKS API endpoint]
            subgraph AKS Cluster
                SYS[System node pool]
                USER[User node pool]
            end
        end
    end
    ENTRA --> API
    API --> SYS
    API --> USER
    SYS --> LA
    USER --> LA
```

## Step-by-Step Instructions

### Step 1: Create resource group and workspace

```bash
az group create \
    --name "$RG" \
    --location "$LOCATION"

az monitor log-analytics workspace create \
    --resource-group "$RG" \
    --workspace-name "$WORKSPACE_NAME" \
    --location "$LOCATION"
```

| Command | Purpose |
| --- | --- |
| `az group create` | Create the resource group for the lab. |
| `--name` | Name of the resource group. |
| `--location` | Azure region for the resource group. |
| `az monitor log-analytics workspace create` | Create the Log Analytics workspace. |
| `--resource-group` | Resource group that contains the workspace. |
| `--workspace-name` | Name of the Log Analytics workspace. |
| `--location` | Azure region for the workspace. |

This step is important because it establishes the control point for **create resource group and workspace**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

### Step 2: Create virtual network and subnet

```bash
az network vnet create \
    --resource-group "$RG" \
    --name "$VNET_NAME" \
    --address-prefixes 10.40.0.0/16 \
    --subnet-name "$AKS_SUBNET_NAME" \
    --subnet-prefixes 10.40.0.0/22
```

| Command | Purpose |
| --- | --- |
| `az network vnet create` | Create the virtual network and AKS subnet. |
| `--resource-group` | Resource group that contains the virtual network. |
| `--name` | Name of the virtual network. |
| `--address-prefixes` | Address space for the virtual network. |
| `--subnet-name` | Name of the AKS subnet. |
| `--subnet-prefixes` | Address range for the AKS subnet. |

This step is important because it establishes the control point for **create virtual network and subnet**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

### Step 3: Deploy the private AKS cluster

```bash
az aks create \
    --resource-group "$RG" \
    --name "$CLUSTER_NAME" \
    --location "$LOCATION" \
    --enable-private-cluster \
    --network-plugin azure \
    --network-plugin-mode overlay \
    --vnet-subnet-id "$AKS_SUBNET_ID" \
    --nodepool-name system \
    --node-count 3 \
    --node-vm-size Standard_D4s_v5 \
    --enable-cluster-autoscaler \
    --min-count 3 \
    --max-count 6 \
    --enable-managed-identity \
    --enable-aad \
    --enable-azure-rbac \
    --enable-oidc-issuer \
    --enable-workload-identity \
    --workspace-resource-id "$WORKSPACE_ID"
```

| Command | Purpose |
| --- | --- |
| `az aks create` | Create a private AKS cluster on a dedicated subnet. |
| `--resource-group` | Resource group that contains the AKS cluster. |
| `--name` | Name of the AKS cluster. |
| `--location` | Azure region for the cluster. |
| `--enable-private-cluster` | Create the cluster with a private API server. |
| `--network-plugin` | Container networking plugin. |
| `--network-plugin-mode` | Network plugin mode such as overlay. |
| `--vnet-subnet-id` | Resource ID of the AKS subnet. |
| `--nodepool-name` | Name of the initial system node pool. |
| `--node-count` | Number of nodes in the system pool. |
| `--node-vm-size` | VM size for the system pool nodes. |
| `--enable-cluster-autoscaler` | Turn on the cluster autoscaler for the pool. |
| `--min-count` | Minimum node count for autoscaling. |
| `--max-count` | Maximum node count for autoscaling. |
| `--enable-managed-identity` | Use a managed identity instead of a service principal. |
| `--enable-aad` | Enable Microsoft Entra integration. |
| `--enable-azure-rbac` | Use Azure RBAC for Kubernetes authorization. |
| `--enable-oidc-issuer` | Enable the OIDC issuer for workload identity. |
| `--enable-workload-identity` | Enable Microsoft Entra Workload ID. |
| `--workspace-resource-id` | Log Analytics workspace for Container Insights. |

This step is important because it establishes the control point for **deploy the private aks cluster**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

### Step 4: Fetch credentials and inspect the cluster

```bash
az aks get-credentials \
    --resource-group "$RG" \
    --name "$CLUSTER_NAME" \
    --overwrite-existing

kubectl get nodes \
    --output wide
```

| Command | Purpose |
| --- | --- |
| `az aks get-credentials` | Merge cluster credentials into the local kubeconfig. |
| `--resource-group` | Resource group that contains the AKS cluster. |
| `--name` | Name of the AKS cluster. |
| `--overwrite-existing` | Overwrite any existing kubeconfig entry for the cluster. |
| `kubectl get nodes` | List cluster nodes to confirm readiness. |

This step is important because it establishes the control point for **fetch credentials and inspect the cluster**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

### Step 5: Add a user node pool and labels

```bash
az aks nodepool add \
    --resource-group "$RG" \
    --cluster-name "$CLUSTER_NAME" \
    --name apps \
    --mode User \
    --node-vm-size Standard_D8s_v5 \
    --node-count 2 \
    --enable-cluster-autoscaler \
    --min-count 2 \
    --max-count 10 \
    --labels workload=app environment=lab
```

| Command | Purpose |
| --- | --- |
| `az aks nodepool add` | Add a user node pool for lab applications. |
| `--resource-group` | Resource group that contains the AKS cluster. |
| `--cluster-name` | Name of the AKS cluster. |
| `--name` | Name of the new node pool. |
| `--mode` | Node pool mode, User for application workloads. |
| `--node-vm-size` | VM size for the pool nodes. |
| `--node-count` | Initial number of nodes in the pool. |
| `--enable-cluster-autoscaler` | Turn on the cluster autoscaler for the pool. |
| `--min-count` | Minimum node count for autoscaling. |
| `--max-count` | Maximum node count for autoscaling. |
| `--labels` | Kubernetes labels applied to the pool nodes. |

This step is important because it establishes the control point for **add a user node pool and labels**. After running it, pause and verify the Azure resource state before moving on so you do not compound errors later in the lab.

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

- [Production Baseline](../../best-practices/production-baseline.md)
- [Node Pools](../../platform/node-pools.md)

## Sources

- [Azure / Aks / Learn / Quick Kubernetes Deploy Cli](https://learn.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-cli)
- [Azure / Aks / Concepts Network](https://learn.microsoft.com/azure/aks/concepts-network)
- [Azure / Aks / Csi Secrets Store Driver](https://learn.microsoft.com/azure/aks/csi-secrets-store-driver)
- [Azure / Governance / Policy / Concepts / Policy For Kubernetes](https://learn.microsoft.com/azure/governance/policy/concepts/policy-for-kubernetes)
- [Azure / Azure Monitor / Containers / Container Insights Overview](https://learn.microsoft.com/azure/azure-monitor/containers/container-insights-overview)
