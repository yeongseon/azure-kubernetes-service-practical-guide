using './main.bicep'

param clusterName = 'aks-baseline-demo'
param location = 'koreacentral'
param dnsPrefix = 'aksbaselinedemo'
param vnetName = 'vnet-aks-baseline-demo'
param aksSubnetName = 'snet-aks'
param logAnalyticsWorkspaceName = 'log-aks-baseline-demo'
param acrName = 'aksbaselinedemoacr'
param keyVaultName = 'kv-aks-baseline-demo'
param vnetAddressPrefixes = [
  '10.40.0.0/16'
]
param aksSubnetPrefix = '10.40.0.0/22'
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
