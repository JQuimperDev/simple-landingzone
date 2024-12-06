using './main.bicep'

param managementGroups = {
  Level1: [
    {
      name: 'mg-contoso'
      displayName: 'Contoso'
    }
    {
      name: 'mg-student'
      displayName: 'Bénéfices étudiants'
    }
    {
      name: 'mg-unmanaged'
      displayName: 'Non géré'
    }
  ]
  Level2: [
    {
      name: 'mg-platform'
      displayName: 'Plateforme'
      parentName: 'mg-contoso'
    }
    {
      name: 'mg-sandbox'
      displayName: 'Bac à sable'
      parentName: 'mg-contoso'
    }
    {
      name: 'mg-lz'
      displayName: 'Zones de charges'
      parentName: 'mg-contoso'
    }
  ]
  Level3: [
    {
      name: 'mg-identity'
      displayName: 'Identité'
      parentName: 'mg-platform'
    }
    {
      name: 'mg-connectivity'
      displayName: 'Connectivité'
      parentName: 'mg-platform'
    }
    {
      name: 'mg-management'
      displayName: 'Gestion'
      parentName: 'mg-platform'
    }
    {
      name: 'mg-pedagogy'
      displayName: 'Pédagogie'
      parentName: 'mg-lz'
    }
    {
      name: 'mg-sti'
      displayName: 'STI'
      parentName: 'mg-lz'
    }
  ]
  Level4: [
    {
      name: 'mg-sentinel'
      displayName: 'Sentinel'
      parentName: 'mg-management'
    }
    {
      name: 'mg-dessin101'
      displayName: 'Dessin 101'
      parentName: 'mg-pedagogy'
    }
    {
      name: 'mg-dessin102'
      displayName: 'Dessin 102'
      parentName: 'mg-pedagogy'
    }
    {
      name: 'mg-modernization'
      displayName: 'Modernisation'
      parentName: 'mg-sti'
    }
    {
      name: 'mg-pccti'
      displayName: 'VM PCC'
      parentName: 'mg-sti'
    }
  ]
}
param defaultManagementGroup = 'mg-student'
param requireAuthorizationForGroupCreation = true

