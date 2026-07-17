---
content_sources:
  - type: self-generated
    justification: "Hub page for the Language Guides extension section"
---

# Language Guides

Language Guides provide end-to-end instructions for containerizing and deploying applications to Azure Kubernetes Service (AKS) using specific programming languages and runtimes.

These guides focus on the developer experience, walking through the transition from local code to a cloud-native deployment that follows the platform's production patterns.

## Available Guides

| Language | Pattern Covered | Status |
|----------|-----------------|--------|
| [Python](./python-on-aks.md) | FastAPI + Workload Identity + Key Vault CSI | Available |
| Node.js | Deferred | Planned |
| .NET | Deferred | Planned |
| Java | Deferred | Planned |

## Core Patterns

Every guide in this section demonstrates at least one of these core AKS patterns:

- **Identity**: Using Microsoft Entra Workload Identity instead of static secrets.
- **Secrets**: Mounting Azure Key Vault secrets via the Secrets Store CSI Driver.
- **Exposure**: Publishing the application through a Kubernetes Service and Ingress.
- **Scale**: Implementing horizontal scaling based on resource utilization.

## See Also

- [Start Here](../start-here/overview.md)
- [Platform Architecture](../platform/index.md)
- [Best Practices](../best-practices/index.md)

## Sources

- https://learn.microsoft.com/en-us/azure/aks/
- https://learn.microsoft.com/en-us/azure/developer/intro/azure-developer-overview
