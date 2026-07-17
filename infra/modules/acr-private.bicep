targetScope = 'resourceGroup'

@description('Location for the Azure Container Registry.')
param location string = resourceGroup().location

@description('Azure Container Registry name.')
param acrName string

@description('ACR SKU. Use Premium when private endpoints are enabled.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Standard'

@description('Create a private endpoint and supporting private DNS zone for the registry.')
param enablePrivateEndpoint bool = false

@description('Subnet resource ID used for the registry private endpoint.')
param privateEndpointSubnetId string = ''

@description('Virtual network resource ID linked to the private DNS zone.')
param vnetId string = ''

@description('Public network access setting. Set to Disabled when using the private variant.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

var privateDnsZoneName = 'privatelink.azurecr.io'
var privateEndpointName = 'pe-${acrName}'
var privateDnsZoneGroupName = 'default'
var privateDnsVnetLinkName = 'link-${acrName}'

resource registry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: false
    publicNetworkAccess: publicNetworkAccess
    networkRuleBypassOptions: 'AzureServices'
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = if (enablePrivateEndpoint) {
  name: privateDnsZoneName
  location: 'global'
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = if (enablePrivateEndpoint) {
  name: privateDnsVnetLinkName
  parent: privateDnsZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = if (enablePrivateEndpoint) {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'acrRegistry'
        properties: {
          privateLinkServiceId: registry.id
          groupIds: [
            'registry'
          ]
        }
      }
    ]
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = if (enablePrivateEndpoint) {
  name: privateDnsZoneGroupName
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'registryDns'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}

output acrId string = registry.id
output acrName string = registry.name
output loginServer string = registry.properties.loginServer
output privateEndpointId string = enablePrivateEndpoint ? privateEndpoint.id : ''
output privateDnsZoneId string = enablePrivateEndpoint ? privateDnsZone.id : ''
