# Best Practices

Production-ready patterns for running workloads on Azure Kubernetes Service.

## Cluster Configuration

### Use Managed Identity

```bash
az aks create \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --enable-managed-identity
```

### Enable Azure Policy

```bash
az aks enable-addons \
    --addons azure-policy \
    --resource-group myResourceGroup \
    --name myAKSCluster
```

## Resource Management

### Set Resource Requests and Limits

```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "250m"
  limits:
    memory: "256Mi"
    cpu: "500m"
```

### Use Pod Disruption Budgets

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: app-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: myapp
```

## Security

- Enable Azure AD integration
- Use network policies
- Scan container images
- Rotate credentials regularly

## See Also

- [Platform Overview](../platform/index.md)
- [Operations](../operations/index.md)

## Sources

- [AKS best practices](https://learn.microsoft.com/en-us/azure/aks/best-practices)
