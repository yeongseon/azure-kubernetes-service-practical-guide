# Visualization Maps

Visual maps provide a high-level mental model for AKS architecture, traffic flows, identity integration, and troubleshooting routing. These maps are designed to be a deliberate learning surface that complements the detailed documentation sections.

## Available Maps

| Map | Purpose |
|---|---|
| [Architecture Map](architecture-map.md) | High-level view of AKS control plane, node pools, and core integrations |
| [Networking Path Map](networking-path-map.md) | Visualizing ingress, egress, and private management traffic paths |
| [Identity Map](identity-map.md) | Understanding Microsoft Entra Workload Identity and Key Vault integration |
| [Troubleshooting Decision Map](troubleshooting-decision-map.md) | Symptom-based routing to diagnostic playbooks |

## How to Use These Maps

- **Start with the big picture**: Use the Architecture Map to understand how components relate before diving into specific platform docs.
- **Trace the path**: Use the Networking and Identity maps to verify configuration requirements for your workloads.
- **Route your diagnosis**: Use the Troubleshooting Decision Map during incidents to find the right playbook quickly.

Maps are synthesized from official Microsoft Learn documentation to ensure accuracy while prioritizing readability.

## See Also

- [Platform Architecture](../platform/cluster-architecture.md)
- [Networking Models](../platform/networking-models.md)
- [Troubleshooting Overview](../troubleshooting/index.md)
