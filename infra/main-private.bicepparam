using './main-private.bicep'

param clusterName = 'aks-baseline-private-demo'
param location = 'koreacentral'
param dnsPrefix = 'aksbaselineprivatedemo'
param vnetName = 'vnet-aks-baseline-private-demo'
param aksSubnetName = 'snet-aks'
param privateEndpointSubnetName = 'snet-private-endpoints'
param logAnalyticsWorkspaceName = 'log-aks-baseline-private-demo'
param acrName = 'aksbaselineprivdemoacr'
param keyVaultName = 'kv-aks-base-private'
param vnetAddressPrefixes = [
  '10.40.0.0/16'
]
param aksSubnetPrefix = '10.40.0.0/22'
param privateEndpointSubnetPrefix = '10.40.4.0/24'
param podCidr = '192.168.0.0/16'
param serviceCidr = '10.0.0.0/16'
param dnsServiceIP = '10.0.0.10'
param logAnalyticsRetentionInDays = 30
param systemNodeVmSize = 'Standard_D4s_v5'
param systemNodeCount = 3
param systemNodeMinCount = 3
param systemNodeMaxCount = 6
param availabilityZones = [
  '1'
  '2'
  '3'
]
