targetScope = 'subscription'

@description('Environment for the deployment.')
param env string

@description('Provide the ID of the management group that you want to move the subscription to.')
param targetMgId string

@description('Provide the ID of the existing subscription for the hub.')
param subscriptionId string

@description('Location for all resources inherited from the deployment.')
param location string = deployment().location

@description('Configuration for the virtual network.')
param vnetConfig object

@description('Configuration for the virtual machine.')
param virtualMachineConfig object

var resourceSuffix = env == 'prod' ? '' : '-${env}'
var rgName = 'rg-hub${resourceSuffix}'
var vnetName = 'vnet-hub${resourceSuffix}'
var vmName = 'vm-hub${resourceSuffix}'
var bastionName = 'bas-hub${resourceSuffix}'

resource moveSubscriptionToRightManagementGroup 'Microsoft.Management/managementGroups/subscriptions@2020-05-01' = {
  scope: tenant()
  name: '${targetMgId}/${subscriptionId}'
}

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  dependsOn: [
    moveSubscriptionToRightManagementGroup
  ]
  name: rgName
  location: location
}

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.5.1' = {
  name: 'virtualNetworkDeployment'
  scope: rg
  params: {
    addressPrefixes: [
      vnetConfig.vnetAddressPrefix
    ]
    name: vnetName
    location: location
    subnets: vnetConfig.subnets
  }
}

module bastionHost 'br/public:avm/res/network/bastion-host:0.5.0' = {
  name: 'bastionHostDeployment'
  scope: rg
  params: {
    // Required parameters
    name: bastionName
    virtualNetworkResourceId: virtualNetwork.outputs.resourceId
    location: location
    publicIPAddressObject: {
      allocationMethod: 'Static'
      name: 'pip-${bastionName}'
      publicIPPrefixResourceId: ''
      skuName: 'Standard'
      skuTier: 'Regional'
      zones: [
        1
      ]
    }
    skuName: 'Basic'
  }
}

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.10.0' = {
  name: 'virtualMachineDeployment'
  scope: rg
  params: {
    adminUsername: virtualMachineConfig.adminUsername
    adminPassword: virtualMachineConfig.adminPassword
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: vmName
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
          }
        ]
        nicprefix: 'nic-'
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    encryptionAtHost: false
    secureBootEnabled: true
    zone: 0
    autoShutdownConfig: {
      dailyRecurrenceTime: '19:00'
      status: 'Enabled'
      timeZone: 'Eastern Standard Time'
    }
  }
}
