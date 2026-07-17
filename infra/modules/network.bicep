targetScope = 'resourceGroup'

@description('Location for all network resources.')
param location string = resourceGroup().location

@description('Virtual network name.')
param vnetName string

@description('AKS subnet name.')
param aksSubnetName string = 'snet-aks'

@description('Private endpoint subnet name.')
param privateEndpointSubnetName string = 'snet-private-endpoints'

@description('Virtual network address spaces.')
param vnetAddressPrefixes array = [
  '10.40.0.0/16'
]

@description('AKS subnet address prefix. Azure CNI Overlay still requires node subnet capacity for nodes, upgrades, and autoscaler headroom.')
param aksSubnetPrefix string = '10.40.0.0/22'

@description('Private endpoint subnet address prefix used by the private baseline.')
param privateEndpointSubnetPrefix string = '10.40.4.0/24'

@description('Deploy the private endpoint subnet and its NSG.')
param deployPrivateEndpointSubnet bool = false

@description('AKS subnet NSG name. Leave empty to derive from the VNet name.')
param aksSubnetNsgName string = ''

@description('Private endpoint subnet NSG name. Leave empty to derive from the VNet name.')
param privateEndpointSubnetNsgName string = ''

var resolvedAksSubnetNsgName = empty(aksSubnetNsgName) ? 'nsg-${aksSubnetName}' : aksSubnetNsgName
var resolvedPrivateEndpointSubnetNsgName = empty(privateEndpointSubnetNsgName) ? 'nsg-${privateEndpointSubnetName}' : privateEndpointSubnetNsgName

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
  }
}

resource aksSubnetNsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: resolvedAksSubnetNsgName
  location: location
  properties: {
    securityRules: []
  }
}

resource privateEndpointSubnetNsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = if (deployPrivateEndpointSubnet) {
  name: resolvedPrivateEndpointSubnetNsgName
  location: location
  properties: {
    securityRules: []
  }
}

resource aksSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  name: aksSubnetName
  parent: vnet
  properties: {
    addressPrefix: aksSubnetPrefix
    networkSecurityGroup: {
      id: aksSubnetNsg.id
    }
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = if (deployPrivateEndpointSubnet) {
  name: privateEndpointSubnetName
  parent: vnet
  properties: {
    addressPrefix: privateEndpointSubnetPrefix
    networkSecurityGroup: {
      id: privateEndpointSubnetNsg.id
    }
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
output aksSubnetId string = aksSubnet.id
output aksSubnetName string = aksSubnet.name
output aksSubnetNsgId string = aksSubnetNsg.id
output privateEndpointSubnetId string = deployPrivateEndpointSubnet ? privateEndpointSubnet.id : ''
output privateEndpointSubnetName string = deployPrivateEndpointSubnet ? privateEndpointSubnet.name : ''
output privateEndpointSubnetNsgId string = deployPrivateEndpointSubnet ? privateEndpointSubnetNsg.id : ''
