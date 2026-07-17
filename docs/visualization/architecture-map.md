---
content_sources:
  diagrams:
  - id: visualization-architecture-map
    type: flowchart
    source: self-generated
    justification: Synthesized AKS architecture overview combining control plane, node pools, and core Azure integrations.
    based_on:
    - https://learn.microsoft.com/en-us/azure/aks/concepts-clusters-workloads
    - https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks
---

# Architecture Map

This map visualizes the relationship between the AKS control plane, various node pool types, and core Azure infrastructure integrations.

## AKS Component Relationships

<!-- diagram-id: visualization-architecture-map -->
```mermaid
flowchart TD
    subgraph AzureManaged [Azure Managed Control Plane]
        API[API Server]
        ETCD[etcd]
        SCH[Scheduler]
        CM[Controller Manager]
    end

    subgraph CustomerVNet [Customer Virtual Network]
        subgraph SystemPool [System Node Pool]
            SN1[System Nodes]
            DNS[CoreDNS]
            TUN[Konnectivity]
        end

        subgraph UserPool [User Node Pools]
            UN1[General Purpose Nodes]
            UN2[GPU / Specialized Nodes]
            UN3[Spot Nodes]
        end
    end

    subgraph Integrations [Azure Integrations]
        ENTRA[Microsoft Entra ID]
        ACR[Azure Container Registry]
        LB[Load Balancer]
        AKV[Azure Key Vault]
        DISK[Azure Disk / Files]
    end

    API --- TUN
    TUN --- SN1
    API --- UN1
    
    SN1 --- DNS
    UN1 --- ENTRA
    UN1 --- AKV
    UN1 --- DISK
    
    UserPool --- LB
    SystemPool --- ACR
```

## How to Read This Map

- **Control Plane**: Fully managed by Azure; you interact with it via the API Server.
- **Node Pools**: Separated into System (for cluster-critical services) and User (for your applications) pools.
- **Integrations**: Standard Azure services that provide identity, storage, networking, and image hosting.

## Where to Go Deeper

- [Cluster Architecture](../platform/cluster-architecture.md)
- [Node Pools](../platform/node-pools.md)
- [Identity and Secrets](../platform/identity-and-secrets.md)

## See Also

- [Platform Overview](../platform/index.md)
- [Production Baseline](../best-practices/production-baseline.md)

## Sources

- [AKS core concepts](https://learn.microsoft.com/en-us/azure/aks/concepts-clusters-workloads)
- [Azure Kubernetes Service (AKS) baseline architecture](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)
