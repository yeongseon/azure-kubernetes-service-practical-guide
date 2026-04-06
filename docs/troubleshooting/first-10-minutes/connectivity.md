# Connectivity

Use this checklist when traffic fails somewhere between ingress and pod.

## Main Content

```mermaid
flowchart LR
    A[Connectivity issue] --> B[Check ingress]
    B --> C[Check service]
    C --> D[Check endpoints]
    D --> E[Test DNS and network policy]
```


```bash
kubectl get ingress -A
kubectl get svc -A
kubectl get endpoints -A
kubectl describe ingress <ingress-name> -n <namespace>
kubectl exec -it <pod-name> -n <namespace> -- nslookup <service-name>
```

## See Also

- [Ingress Failure](../playbooks/connectivity/ingress-failure.md)
- [Service Unreachable](../playbooks/connectivity/service-unreachable.md)
- [Diagnostic Commands](../../reference/diagnostic-commands.md)

## Sources

- [Troubleshoot AKS clusters](https://learn.microsoft.com/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)
- [AKS troubleshooting articles](https://learn.microsoft.com/troubleshoot/azure/azure-kubernetes/)
