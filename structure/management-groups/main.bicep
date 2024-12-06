
targetScope = 'tenant'

param managementGroups object
param defaultManagementGroup string
param requireAuthorizationForGroupCreation bool

resource deployManagementGroupsLevel1 'Microsoft.Management/managementGroups@2020-05-01' = [for mg in managementGroups.Level1: {
  name: mg.name
  scope: tenant()
  properties: {
    displayName: mg.displayName
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', tenant().tenantId)
      }
    }
  }
}]

resource deployManagementGroupsLevel2 'Microsoft.Management/managementGroups@2020-05-01' = [for mg in managementGroups.Level2: {
  dependsOn: deployManagementGroupsLevel1
  name: mg.name
  scope: tenant()
  properties: {
    displayName: mg.displayName
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', mg.parentName)
      }
    }
  }
}]

resource deployManagementGroupsLevel3 'Microsoft.Management/managementGroups@2020-05-01' = [for mg in managementGroups.Level3: {
  dependsOn: deployManagementGroupsLevel2
  name: mg.name
  scope: tenant()
  properties: {
    displayName: mg.displayName
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', mg.parentName)
      }
    }
  }
}]

resource deployManagementGroupsLevel4 'Microsoft.Management/managementGroups@2020-05-01' = [for mg in managementGroups.Level4: {
  dependsOn: deployManagementGroupsLevel3
  name: mg.name
  scope: tenant()
  properties: {
    displayName: mg.displayName
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', mg.parentName)
      }
    }
  }
}]

// Set default management group for subscriptions if specified in parameters
resource mgSettings 'Microsoft.Management/managementGroups/settings@2021-04-01' = if (!empty(defaultManagementGroup)) {
  name: '${tenant().tenantId}/default'
  properties: {
    defaultManagementGroup: resourceId('Microsoft.Management/managementGroups', defaultManagementGroup)
    requireAuthorizationForGroupCreation: requireAuthorizationForGroupCreation
  }
}
