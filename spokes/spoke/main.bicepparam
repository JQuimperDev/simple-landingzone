using './main.bicep'

param env = 'prod'
param location = 'canadacentral'
param subscriptionId =  ''
param targetMgId =  ''

param vnetConfig = {
  hubVnetName: ''
  hubRgName: ''
  vnetAddressPrefix: '10.2.0.0/16'
  subnets: [
    {
      name: 'vm-subnet'
      addressPrefix:'10.2.1.0/24'
    }
  ]
}
