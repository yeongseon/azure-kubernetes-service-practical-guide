# Operations

Day-2 operational tasks for managing AKS clusters in production.

## Scaling

### Manual Scaling

```bash
# Scale node pool
az aks scale \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --node-count 5

# Scale deployment
kubectl scale deployment myapp --replicas=5
```

### Cluster Autoscaler

```bash
az aks update \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 10
```

## Upgrades

### Check Available Versions

```bash
az aks get-upgrades \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --output table
```

### Upgrade Cluster

```bash
az aks upgrade \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --kubernetes-version 1.28.0
```

## Monitoring

### Enable Container Insights

```bash
az aks enable-addons \
    --addons monitoring \
    --resource-group myResourceGroup \
    --name myAKSCluster
```

## See Also

- [Platform Overview](../platform/index.md)
- [Troubleshooting](../troubleshooting/index.md)

## Sources

- [Scale AKS cluster](https://learn.microsoft.com/en-us/azure/aks/scale-cluster)
- [Upgrade AKS cluster](https://learn.microsoft.com/en-us/azure/aks/upgrade-cluster)
