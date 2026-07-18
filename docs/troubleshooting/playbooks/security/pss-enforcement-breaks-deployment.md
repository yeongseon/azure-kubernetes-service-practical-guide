---
description: Troubleshoot AKS deployment failures caused by Pod Security Standards enforcement and namespace-level PSA labels.
content_sources:
  diagrams:
    - id: troubleshooting-security-pss-enforcement-breaks-deployment
      type: flowchart
      source: self-generated
      justification: PSS enforcement diagnostic flow synthesized from Microsoft Learn PSA, deployment safeguards, and pod security best practice guidance.
      based_on:
        - https://learn.microsoft.com/en-us/azure/aks/use-psa
        - https://learn.microsoft.com/en-us/azure/aks/deployment-safeguards
        - https://learn.microsoft.com/en-us/azure/aks/developer-best-practices-pod-security
content_validation:
  status: verified
  last_reviewed: 2026-07-18
  reviewer: agent
  core_claims:
    - claim: "Pod Security Admission uses labels to enforce Pod Security Standards policies on pods running in a namespace."
      source: https://learn.microsoft.com/en-us/azure/aks/use-psa
      verified: true
    - claim: "Pod Security Admission is enabled by default in AKS."
      source: https://learn.microsoft.com/en-us/azure/aks/use-psa
      verified: true
    - claim: "The securityContext for a pod or container can define settings such as runAsUser or fsGroup."
      source: https://learn.microsoft.com/en-us/azure/aks/developer-best-practices-pod-security
      verified: true
    - claim: "allowPrivilegeEscalation defines if the pod can assume root privileges."
      source: https://learn.microsoft.com/en-us/azure/aks/developer-best-practices-pod-security
      verified: true
---

# PSS Enforcement Breaks Deployment

## Symptom

A workload deploys successfully in one namespace but fails or warns in another after Pod Security Standards enforcement is introduced.

## Possible Causes

- The namespace moved from `privileged` to `baseline` or `restricted`.
- The manifest lacks `securityContext` settings required by the target profile.
- The workload adds Linux capabilities or relies on privilege escalation.
- The workload expects host access patterns that the target profile does not allow.
- A namespace exemption that previously existed was removed.

## Diagnosis Steps

<!-- diagram-id: troubleshooting-security-pss-enforcement-breaks-deployment -->
```mermaid
flowchart TD
    A[Deployment blocked by PSS] --> B[Inspect namespace labels]
    B --> C[Read warning or denial details]
    C --> D{Missing securityContext or capabilities issue?}
    D -->|Yes| E[Fix manifest for target profile]
    D -->|No| F{Wrong namespace profile or missing exemption?}
    F -->|Yes| G[Adjust namespace rollout or approved exemption]
    F -->|No| H[Re-test under warn or audit mode]
```

1. Inspect the target namespace labels.

    ```bash
    kubectl get namespace <namespace> \
        --show-labels
    ```

2. Capture the exact warning or denial details from the deployment output.

3. Inspect the workload manifest for common restricted-profile blockers:

    - missing `runAsNonRoot`,
    - missing `allowPrivilegeEscalation: false`,
    - added Linux capabilities,
    - missing `seccompProfile`,
    - broad host access assumptions.

4. Describe the workload object for admission events.

    ```bash
    kubectl describe deployment <deployment-name> \
        --namespace <namespace>
    ```

5. Compare the namespace target profile with the workload's actual trust level.

## Resolution

- Update the workload manifest so it meets the target PSS profile.
- If the namespace was moved too aggressively, step back to `warn` or `audit` while the team remediates manifests.
- Use a tightly scoped namespace exemption only when the workload genuinely requires higher privilege and the exception is approved.
- Keep platform and application teams aligned on whether the namespace should stay `privileged`, `baseline`, or `restricted`.

## Prevention

- Roll out PSS with `warn` or `audit` before `enforce`.
- Publish a standard workload manifest template that already includes compliant `securityContext` defaults.
- Track exemption namespaces with expiry and owner.
- Review privileged or host-access workloads separately before namespace-level promotion to `restricted`.

## See Also

- [Pod Security Standards](../../../platform/pod-security-standards.md)
- [Azure Policy Add-on](../../../platform/azure-policy-addon.md)
- [Best Practices: Governance](../../../best-practices/governance.md)
- [Best Practices: Security](../../../best-practices/security.md)

## Sources

- [Use Pod Security Admission in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/use-psa)
- [Use Deployment Safeguards to Enforce Best Practices in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/deployment-safeguards)
- [Developer best practices - Pod security in Azure Kubernetes Services (AKS)](https://learn.microsoft.com/en-us/azure/aks/developer-best-practices-pod-security)
