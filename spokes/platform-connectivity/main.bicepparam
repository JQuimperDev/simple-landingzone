using './main.bicep'

param env = 'prod'
param location = 'canadacentral'
param subscriptionId =  ''
param targetMgId =  ''

param vnetConfig = {
  vnetAddressPrefix: '10.0.0.0/16'
  subnets: [
    {
      name: 'vm-subnet'
      addressPrefix:'10.0.1.0/24'
    }
    {
      name: 'AzureBastionSubnet'
      addressPrefix:'10.0.9.0/24'
    }
  ]
}

param virtualMachineConfig = {
  adminUsername: ''
  adminPassword: ''
}
