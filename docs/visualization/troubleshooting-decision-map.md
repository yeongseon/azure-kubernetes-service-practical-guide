---
content_sources:
  diagrams:
  - id: visualization-troubleshooting-map
    type: flowchart
    source: self-generated
    justification: Visual routing map to navigate from high-level symptoms to specific troubleshooting playbooks.
    based_on:
    - https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes
    - https://learn.microsoft.com/en-us/azure/aks/troubleshooting
---

# Troubleshooting Decision Map

Use this map to quickly route from an observed symptom to the relevant diagnostic playbook.

## Symptom to Playbook Routing

<!-- diagram-id: visualization-troubleshooting-map -->
```mermaid
flowchart TD
    Start[Observed Symptom] --> PodIssues{Pod Issues?}
    Start --> NodeIssues{Node Issues?}
    Start --> ConnectivityIssues{Connectivity?}
    Start --> OperationIssues{Operation Fail?}

    PodIssues -->|CrashLoop| P1[CrashLoopBackOff Playbook]
    PodIssues -->|Pending| P2[Pending Pods Playbook]
    PodIssues -->|ImagePull| P3[Image Pull Failure Playbook]

    NodeIssues -->|NotReady| N1[Node Not Ready Playbook]
    NodeIssues -->|IP Exhaust| N2[CNI IP Exhaustion Playbook]

    ConnectivityIssues -->|Ingress| C1[Ingress Failure Playbook]
    ConnectivityIssues -->|Service| C2[Service Unreachable Playbook]

    OperationIssues -->|Upgrade| O1[Upgrade Failure Playbook]
    OperationIssues -->|Scaling| O2[Scaling Failure Playbook]

    click P1 "../troubleshooting/playbooks/pod-issues/crashloop.md" "View Playbook"
    click P2 "../troubleshooting/playbooks/pod-issues/pending-pods.md" "View Playbook"
    click P3 "../troubleshooting/playbooks/pod-issues/image-pull-failure.md" "View Playbook"
    click N1 "../troubleshooting/playbooks/node-issues/node-not-ready.md" "View Playbook"
    click N2 "../troubleshooting/playbooks/node-issues/cni-ip-exhaustion.md" "View Playbook"
    click C1 "../troubleshooting/playbooks/connectivity/ingress-failure.md" "View Playbook"
    click C2 "../troubleshooting/playbooks/connectivity/service-unreachable.md" "View Playbook"
    click O1 "../troubleshooting/playbooks/operations/upgrade-failure.md" "View Playbook"
    click O2 "../troubleshooting/playbooks/operations/scaling-failure.md" "View Playbook"
```

## How to Read This Map

1. **Identify the category**: Start by classifying your symptom into Pod, Node, Connectivity, or Operation categories.
2. **Refine the symptom**: Follow the path that most closely matches the specific error message or behavior observed.
3. **Jump to the playbook**: Click the node in the diagram or follow the links below to start the step-by-step diagnostic procedure.

## Where to Go Deeper

- [Troubleshooting Decision Tree](../troubleshooting/decision-tree.md)
- [First 10 Minutes: Quick Diagnosis](../troubleshooting/first-10-minutes/index.md)
- [Mental Model for Troubleshooting](../troubleshooting/mental-model.md)

## See Also

- [Diagnostic Commands](../reference/diagnostic-commands.md)
- [CLI Cheatsheet](../reference/cli-cheatsheet.md)

## Sources

- [Troubleshoot AKS clusters](https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/welcome-azure-kubernetes)
- [AKS troubleshooting overview](https://learn.microsoft.com/en-us/azure/aks/troubleshooting)
