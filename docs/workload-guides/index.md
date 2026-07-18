---
description: Azure Kubernetes Service workload guides for implementation patterns — deployment shape, scaling, probes, networking, identity, and observability by workload type.
content_sources:
  - type: self-generated
    justification: Hub page for workload-pattern guides derived from Microsoft Learn AKS architecture, scaling, ingress, identity, and monitoring guidance.
---

# Workload Guides

Workload Guides are implementation-pattern guides organized by Kubernetes workload shape rather than by programming language. Each guide focuses on the deployment shape, scaling model, probes, networking, identity, observability, and common failure modes for that workload pattern.

## Available Guides

| Workload Pattern | Focus | Status |
|---|---|---|
| [Stateless web API](./stateless-web-api-on-aks.md) | External HTTP API, HPA, Ingress | Available |
| Internal service | East-west service-to-service traffic, ClusterIP, policy boundaries | Planned |
| Background worker | Queue or event-driven processing, retries, graceful shutdown | Planned |
| CronJob (scheduled job) | Time-based execution, concurrency policy, job history | Planned |
| GPU workload (overview) | Node pools, scheduling constraints, accelerator operations | Planned |
| Stateful workload considerations | Persistent storage, disruption handling, rollout boundaries | Planned |

## How These Differ from Language Guides

Language Guides are runtime-first. They show how to containerize and deploy a specific application stack such as Python on AKS.

Workload Guides are shape-first. They assume you already have a containerized application and need a production deployment pattern for a stateless API, internal service, worker, scheduled job, or other workload type.

## See Also

- [Language Guides](../language-guides/index.md)
- [Best Practices](../best-practices/index.md)
- [Platform](../platform/index.md)

## Sources

- https://learn.microsoft.com/en-us/azure/aks/
- https://learn.microsoft.com/en-us/azure/aks/concepts-clusters-workloads
- https://learn.microsoft.com/en-us/azure/aks/best-practices-app-cluster-reliability
