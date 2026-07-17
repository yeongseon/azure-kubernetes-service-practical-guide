---
content_sources:
  diagrams:
  - id: platform-ingress-load-balancing
    type: flowchart
    source: mslearn-adapted
    mslearn_url: https://learn.microsoft.com/en-us/azure/aks/internal-lb
    based_on:
    - https://learn.microsoft.com/en-us/azure/aks/internal-lb
    - https://learn.microsoft.com/en-us/azure/aks/app-routing
---




# Ingress and Load Balancing

AKS traffic entry points combine Kubernetes Services, Azure load balancers, and one or more ingress controllers. Separate north-south routing from east-west service discovery in your design.

## Main Content
<!-- diagram-id: platform-ingress-load-balancing -->
```mermaid
flowchart TD
    U[Users] --> PIP[Public IP or Private IP]
    PIP --> LB[Azure Load Balancer]
    LB --> IC[Ingress Controller]
    IC --> SVC[Service]
    SVC --> PODS[Pods]
```


### Core traffic primitives

- **Service type LoadBalancer** exposes a workload through an Azure load balancer.
- **Ingress** provides HTTP routing, TLS termination strategy, and path/host mapping.
- **Internal load balancer** patterns are common for private platform APIs.

### Common AKS ingress choices

- NGINX Ingress Controller for broad Kubernetes ecosystem compatibility.
- Application Gateway for Containers or app routing add-on when Azure-managed edge integration is preferred.
- Service meshes or gateway APIs for larger platform-standard traffic controls.

> [!WARNING]
> ingress-nginx upstream maintenance ends in March 2026. In AKS, the application routing add-on can continue using NGINX through November 2026, but Gateway API is the recommended long-term direction for new designs.

### Useful commands

```bash
kubectl get ingress -A
kubectl get svc -A
kubectl describe ingress <ingress-name> -n <namespace>
az network public-ip list --resource-group MC_<managed-resource-group>_<cluster-name>_<location> --output table
```

### View services and ingresses in the Azure Portal

The **Services and ingresses** blade lists Kubernetes Services with their type and external endpoint, so you can confirm a `LoadBalancer` service received a public IP.

[[[ shot("aks-networking-services-ingresses") ]]]

Purpose: Confirm that a workload exposed through a `LoadBalancer` service obtained an external endpoint.

Look for:

- The service **type** shows `LoadBalancer` for the exposed workload.
- The **external IP** is populated (and sanitized as `<public-ip>` in this screenshot).
- The service maps to the expected namespace and backing pods.

Expected result: The exposed service has a reachable external endpoint, confirming the Azure load balancer provisioned correctly.

Next step: Add an ingress controller for HTTP routing and TLS termination as described above.

## See Also

- [Networking Models](networking-models.md)
- [Storage Options](storage-options.md)
- [Best Practices: Networking](../best-practices/networking.md)
- [Ingress Failure Playbook](../troubleshooting/playbooks/connectivity/ingress-failure.md)

## Sources

- [Create and use an internal load balancer with AKS](https://learn.microsoft.com/azure/aks/internal-lb)
- [AKS application routing add-on](https://learn.microsoft.com/azure/aks/app-routing)
