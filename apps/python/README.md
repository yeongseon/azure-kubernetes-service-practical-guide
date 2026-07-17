# Python Reference App: Workload Identity + Key Vault CSI

Minimal FastAPI sample that backs [Tutorial 03: Azure Key Vault CSI Driver](../../docs/tutorials/lab-guides/lab-03-azure-key-vault-csi-driver.md). It demonstrates one canonical AKS pattern: a pod uses Microsoft Entra Workload Identity to access Azure Key Vault through the Secrets Store CSI Driver, exposes the app with a Kubernetes `Service`, and publishes it through an `Ingress`.

## Pattern Summary

- **Identity**: `ServiceAccount` named `keyvault-reader` in namespace `workload`
- **Secret mount**: Azure Key Vault secret `app-secret` mounted at `/mnt/secrets-store/app-secret`
- **Exposure**: `Service` on port `80` to container port `8000`, fronted by an `Ingress`
- **Scale**: `HorizontalPodAutoscaler` from 2 to 5 replicas on CPU
- **Security**: Non-root container, read-only root filesystem, dropped capabilities, runtime-default seccomp profile

## Directory Layout

```text
apps/python/
├── Dockerfile
├── manifests/
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── namespace.yaml
│   ├── secretproviderclass.yaml
│   ├── service.yaml
│   └── serviceaccount.yaml
├── requirements.txt
├── src/
│   └── main.py
└── README.md
```

## Prerequisites

- AKS cluster with OIDC issuer and Workload Identity enabled
- Azure Key Vault provider for Secrets Store CSI Driver enabled on the cluster
- Azure Container Registry available for the image
- Existing lab variables: `$RG`, `$CLUSTER_NAME`, `$LOCATION`, `$ACR_NAME`, `$KEYVAULT_NAME`
- Additional variables for this sample:

```bash
export IDENTITY_NAME="keyvault-reader-uami"
export APP_HOSTNAME="keyvault-app.example.com"
export IMAGE_NAME="aks-keyvault-csi-sample"
export IMAGE_TAG="0.1.0"
```

## Build and Push the Image

Build locally and push to Azure Container Registry:

```bash
az acr login \
    --name "$ACR_NAME"

docker build \
    --file Dockerfile \
    --tag "$ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG" \
    .

docker push "$ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG"
```

From the `apps/python/` directory, the image tag matches the placeholder used in `manifests/deployment.yaml`.

## Prepare Azure Resources

If you are following the lab from scratch, create the Key Vault secret and user-assigned managed identity first.

```bash
az keyvault create \
    --resource-group "$RG" \
    --name "$KEYVAULT_NAME" \
    --location "$LOCATION"

az keyvault secret set \
    --vault-name "$KEYVAULT_NAME" \
    --name app-secret \
    --value "demo-value"

az identity create \
    --resource-group "$RG" \
    --name "$IDENTITY_NAME" \
    --location "$LOCATION"
```

Fetch the values required by the manifests and federated credential:

```bash
export OIDC_ISSUER="$(az aks show --resource-group "$RG" --name "$CLUSTER_NAME" --query "oidcIssuerProfile.issuerUrl" --output tsv)"
export UAMI_CLIENT_ID="$(az identity show --resource-group "$RG" --name "$IDENTITY_NAME" --query "clientId" --output tsv)"
export IDENTITY_PRINCIPAL_ID="$(az identity show --resource-group "$RG" --name "$IDENTITY_NAME" --query "principalId" --output tsv)"
export KEYVAULT_ID="$(az keyvault show --name "$KEYVAULT_NAME" --query "id" --output tsv)"
export TENANT_ID="$(az account show --query "tenantId" --output tsv)"
```

Create the federated credential and authorize the identity to read secrets:

```bash
az identity federated-credential create \
    --resource-group "$RG" \
    --identity-name "$IDENTITY_NAME" \
    --name aks-csi-federation \
    --issuer "$OIDC_ISSUER" \
    --subject system:serviceaccount:workload:keyvault-reader \
    --audience api://AzureADTokenExchange

az role assignment create \
    --assignee-object-id "$IDENTITY_PRINCIPAL_ID" \
    --assignee-principal-type ServicePrincipal \
    --role "Key Vault Secrets User" \
    --scope "$KEYVAULT_ID"
```

## Configure the Manifests

Replace these placeholders before applying the manifests:

- `<UAMI_CLIENT_ID>`
- `<KEYVAULT_NAME>`
- `<TENANT_ID>`
- `<ACR_NAME>`
- `<APP_HOSTNAME>`

The lab tutorial uses older standalone filenames such as `keyvault-serviceaccount.yaml`, `secretproviderclass.yaml`, and `keyvault-pod.yaml`. This sample keeps the same logical objects, but organizes them under `manifests/` as reusable Kubernetes resources.

## Deploy to AKS

Apply the namespace first, then the remaining resources:

```bash
kubectl apply \
    --filename manifests/namespace.yaml

kubectl apply \
    --filename manifests/serviceaccount.yaml

kubectl apply \
    --filename manifests/secretproviderclass.yaml

kubectl apply \
    --filename manifests/deployment.yaml

kubectl apply \
    --filename manifests/service.yaml

kubectl apply \
    --filename manifests/ingress.yaml

kubectl apply \
    --filename manifests/hpa.yaml
```

You can also apply the whole directory after placeholders are replaced:

```bash
kubectl apply \
    --filename manifests/
```

## Verification

Confirm the workload is running:

```bash
kubectl get pods \
    --namespace workload \
    --output wide

kubectl get ingress \
    --namespace workload
```

Port-forward the service and call the secret endpoint. The app reports only presence and length, never the secret value.

```bash
kubectl port-forward \
    --namespace workload \
    service/keyvault-app 8000:80
```

In a second terminal:

```bash
curl http://127.0.0.1:8000/secret
```

Expected response after the CSI mount succeeds:

```json
{"secretPresent":true,"secretLength":10,"secretPath":"/mnt/secrets-store/app-secret"}
```

If `secretPresent` is `false`, inspect the pod events and the Secrets Store CSI driver logs before checking the federated credential and Key Vault permissions.

## Cleanup

Remove the Kubernetes resources:

```bash
kubectl delete \
    --filename manifests/
```

Optionally remove the Azure resources created for the lab:

```bash
az identity delete \
    --resource-group "$RG" \
    --name "$IDENTITY_NAME"

az keyvault delete \
    --name "$KEYVAULT_NAME"
```

If this environment is lab-only, you can also remove the full resource group:

```bash
az group delete \
    --name "$RG" \
    --yes \
    --no-wait
```

## See Also

- [Tutorial 03: Azure Key Vault CSI Driver](../../docs/tutorials/lab-guides/lab-03-azure-key-vault-csi-driver.md)
- [Security](../../docs/best-practices/security.md)
- [Production Baseline](../../docs/best-practices/production-baseline.md)

## Sources

- https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster
- https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver
- https://learn.microsoft.com/en-us/azure/aks/operator-best-practices-pod-security
