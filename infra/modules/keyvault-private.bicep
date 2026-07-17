targetScope = 'resourceGroup'

@description('Location for the Key Vault.')
param location string = resourceGroup().location

@description('Key Vault name.')
param keyVaultName string

@description('Tenant ID for the Key Vault.')
param tenantId string = tenant().tenantId

@description('Create a private endpoint and supporting private DNS zone for the Key Vault.')
param enablePrivateEndpoint bool = false

@description('Subnet resource ID used for the Key Vault private endpoint.')
param privateEndpointSubnetId string = ''

@description('Virtual network resource ID linked to the private DNS zone.')
param vnetId string = ''

@description('Public network access setting. Set to Disabled when using the private variant.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

var privateDnsZoneName = 'privatelink.vaultcore.azure.net'
var privateEndpointName = 'pe-${keyVaultName}'
var privateDnsVnetLinkName = 'link-${keyVaultName}'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    softDeleteRetentionInDays: 90
    enablePurgeProtection: true
    publicNetworkAccess: publicNetworkAccess
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: enablePrivateEndpoint ? 'Deny' : 'Allow'
    }
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
        name: 'keyVault'
        properties: {
          privateLinkServiceId: keyVault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = if (enablePrivateEndpoint) {
  name: 'default'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'keyVaultDns'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}

output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
output privateEndpointId string = enablePrivateEndpoint ? privateEndpoint.id : ''
output privateDnsZoneId string = enablePrivateEndpoint ? privateDnsZone.id : ''
