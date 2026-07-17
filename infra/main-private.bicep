targetScope = 'resourceGroup'

@description('AKS cluster name.')
param clusterName string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Optional Kubernetes version. Leave empty to let AKS choose the regional default supported version.')
param kubernetesVersion string = ''

@description('DNS prefix for the AKS API server.')
param dnsPrefix string = take(replace(toLower(clusterName), '-', ''), 20)

@description('Virtual network name.')
param vnetName string = 'vnet-${clusterName}'

@description('AKS subnet name.')
param aksSubnetName string = 'snet-aks'

@description('Private endpoint subnet name.')
param privateEndpointSubnetName string = 'snet-private-endpoints'

@description('Log Analytics workspace name.')
param logAnalyticsWorkspaceName string = 'log-${clusterName}'

@description('Azure Container Registry name. Must be globally unique and alphanumeric.')
param acrName string = take('${replace(toLower(clusterName), '-', '')}${take(uniqueString(resourceGroup().id, clusterName), 8)}', 50)

@description('Key Vault name. Must be globally unique and between 3 and 24 characters.')
param keyVaultName string = take(concat('kv-', clusterName, '-', take(uniqueString(resourceGroup().id, clusterName, 'kv'), 6)), 24)

@description('Address spaces for the AKS virtual network.')
param vnetAddressPrefixes array = [
  '10.40.0.0/16'
]

@description('AKS subnet address prefix.')
param aksSubnetPrefix string = '10.40.0.0/22'

@description('Private endpoint subnet address prefix.')
param privateEndpointSubnetPrefix string = '10.40.4.0/24'

@description('Azure CNI Overlay pod CIDR.')
param podCidr string = '192.168.0.0/16'

@description('Kubernetes service CIDR.')
param serviceCidr string = '10.0.0.0/16'

@description('Kubernetes DNS service IP. Must be inside the service CIDR.')
param dnsServiceIP string = '10.0.0.10'

@description('Log Analytics retention in days.')
@minValue(30)
@maxValue(730)
param logAnalyticsRetentionInDays int = 30

@description('System node pool VM size.')
param systemNodeVmSize string = 'Standard_D4s_v5'

@description('System node pool node count.')
@minValue(3)
param systemNodeCount int = 3

@description('System node pool autoscaler minimum node count.')
@minValue(3)
param systemNodeMinCount int = 3

@description('System node pool autoscaler maximum node count.')
@minValue(3)
param systemNodeMaxCount int = 6

@description('Availability zones for the baseline system node pool.')
param availabilityZones array = [
  '1'
  '2'
  '3'
]

var managedClusterProperties = {
  dnsPrefix: dnsPrefix
  disableLocalAccounts: true
  enableRBAC: true
  aadProfile: {
    managed: true
    enableAzureRBAC: true
  }
  agentPoolProfiles: [
    {
      name: 'system'
      count: systemNodeCount
      vmSize: systemNodeVmSize
      osType: 'Linux'
      type: 'VirtualMachineScaleSets'
      mode: 'System'
      vnetSubnetID: network.outputs.aksSubnetId
      availabilityZones: availabilityZones
      enableAutoScaling: true
      minCount: systemNodeMinCount
      maxCount: systemNodeMaxCount
    }
  ]
  apiServerAccessProfile: {
    enablePrivateCluster: true
    privateDNSZone: 'system'
  }
  networkProfile: {
    networkPlugin: 'azure'
    networkPluginMode: 'overlay'
    networkPolicy: 'azure'
    networkDataplane: 'azure'
    podCidr: podCidr
    serviceCidr: serviceCidr
    dnsServiceIP: dnsServiceIP
    loadBalancerSku: 'standard'
    outboundType: 'loadBalancer'
  }
  addonProfiles: {
    omsagent: {
      enabled: true
      config: {
        logAnalyticsWorkspaceResourceID: monitoring.outputs.workspaceId
      }
    }
    azureKeyvaultSecretsProvider: {
      enabled: true
      config: {
        enableSecretRotation: 'true'
        rotationPollInterval: '2m'
      }
    }
    azurepolicy: {
      enabled: true
    }
  }
  oidcIssuerProfile: {
    enabled: true
  }
  securityProfile: {
    workloadIdentity: {
      enabled: true
    }
  }
  sku: {
    name: 'Base'
    tier: 'Standard'
  }
}

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    location: location
    vnetName: vnetName
    aksSubnetName: aksSubnetName
    privateEndpointSubnetName: privateEndpointSubnetName
    vnetAddressPrefixes: vnetAddressPrefixes
    aksSubnetPrefix: aksSubnetPrefix
    privateEndpointSubnetPrefix: privateEndpointSubnetPrefix
    deployPrivateEndpointSubnet: true
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    workspaceName: logAnalyticsWorkspaceName
    retentionInDays: logAnalyticsRetentionInDays
  }
}

module acr 'modules/acr-private.bicep' = {
  name: 'acr'
  params: {
    location: location
    acrName: acrName
    skuName: 'Premium'
    enablePrivateEndpoint: true
    privateEndpointSubnetId: network.outputs.privateEndpointSubnetId
    vnetId: network.outputs.vnetId
    publicNetworkAccess: 'Disabled'
  }
}

module keyVault 'modules/keyvault-private.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    keyVaultName: keyVaultName
    enablePrivateEndpoint: true
    privateEndpointSubnetId: network.outputs.privateEndpointSubnetId
    vnetId: network.outputs.vnetId
    publicNetworkAccess: 'Disabled'
  }
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: union(managedClusterProperties, empty(kubernetesVersion) ? {} : {
    kubernetesVersion: kubernetesVersion
  })
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' existing = {
  name: acrName
}

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, acrName, clusterName, 'AcrPull')
  scope: containerRegistry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: aksCluster.properties.identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
  }
}

output clusterName string = aksCluster.name
output oidcIssuerUrl string = aksCluster.properties.oidcIssuerProfile.issuerURL
output kubeletIdentity object = aksCluster.properties.identityProfile.kubeletidentity
output acrLoginServer string = acr.outputs.loginServer
output keyVaultName string = keyVault.outputs.keyVaultName
output keyVaultUri string = keyVault.outputs.keyVaultUri
output privateFqdn string = aksCluster.properties.privateFQDN
