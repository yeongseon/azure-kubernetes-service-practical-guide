---
content_sources:
  diagrams:
  - id: start-here-learning-path-architect-path
    type: flowchart
    source: self-generated
    justification: Navigation flow synthesized from the linked AKS topics and workflows
      on this page.
    based_on:
    - https://learn.microsoft.com/en-us/azure/aks/
    - https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes
  - id: start-here-learning-path-operator-path
    type: flowchart
    source: self-generated
    justification: Navigation flow synthesized from the linked AKS topics and workflows
      on this page.
    based_on:
    - https://learn.microsoft.com/en-us/azure/aks/
    - https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes
  - id: start-here-learning-path-troubleshooter-path
    type: flowchart
    source: self-generated
    justification: Navigation flow synthesized from the linked AKS topics and workflows
      on this page.
    based_on:
    - https://learn.microsoft.com/en-us/azure/aks/
    - https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes
---



# Learning Path

Choose a path based on your role so you can move from AKS fundamentals to production execution without skipping key design decisions.

## Main Content

### Architect Path

<!-- diagram-id: start-here-learning-path-architect-path -->
```mermaid
flowchart LR
    A[Overview] --> B[Cluster Architecture]
    B --> C[Networking Models]
    C --> D[Identity and Secrets]
    D --> E[Production Baseline]
```


1. [Overview](overview.md)
2. [AKS vs Other Compute](aks-vs-other-compute.md)
3. [Cluster Architecture](../platform/cluster-architecture.md)
4. [Networking Models](../platform/networking-models.md)
5. [Identity and Secrets](../platform/identity-and-secrets.md)
6. [Production Baseline](../best-practices/production-baseline.md)
7. [Resource Governance](../best-practices/resource-governance.md)

### Operator Path

<!-- diagram-id: start-here-learning-path-operator-path -->
```mermaid
flowchart LR
    A[Prerequisites] --> B[Cluster Creation]
    B --> C[Node Pool Operations]
    C --> D[Upgrades]
    D --> E[Monitoring]
    E --> F[Maintenance Windows]
```


1. [Prerequisites](prerequisites.md)
2. [Cluster Creation](../operations/cluster-creation.md)
3. [Node Pool Operations](../operations/node-pool-operations.md)
4. [Scaling](../platform/scaling.md)
5. [Upgrades](../operations/upgrades.md)
6. [Monitoring and Logging](../operations/monitoring-logging.md)
7. [Credential Rotation](../operations/credential-rotation.md)

### Troubleshooter Path

<!-- diagram-id: start-here-learning-path-troubleshooter-path -->
```mermaid
flowchart LR
    A[Architecture Overview] --> B[Decision Tree]
    B --> C[First 10 Minutes]
    C --> D[Playbooks]
    D --> E[Diagnostic Commands]
```


1. [Architecture Overview](../troubleshooting/architecture-overview.md)
2. [Decision Tree](../troubleshooting/decision-tree.md)
3. [First 10 Minutes](../troubleshooting/first-10-minutes/index.md)
4. [Playbooks](../troubleshooting/playbooks/index.md)
5. [Diagnostic Commands](../reference/diagnostic-commands.md)

## See Also

- [Overview](overview.md)
- [Prerequisites](prerequisites.md)
- [Platform](../platform/index.md)
- [Operations](../operations/index.md)
- [Troubleshooting](../troubleshooting/index.md)

## Sources

- [Azure Kubernetes Service (AKS) documentation](https://learn.microsoft.com/azure/aks/)
- [What is Azure Kubernetes Service (AKS)?](https://learn.microsoft.com/azure/aks/intro-kubernetes)
