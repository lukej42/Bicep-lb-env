param location string = resourceGroup().location
param environment string
param appName string

// --------------------
// Networking
// --------------------
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: 'sharedVNet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'sharedSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: 'sharedNSG'
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// --------------------
// Core Azure Services
// --------------------
module storage './modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    name: '${appName}stg${environment}'
    location: location
  }
}

module keyvault './modules/keyvault.bicep' = {
  name: 'kvDeploy'
  params: {
    name: '${appName}-kv-${environment}'
    location: location
  }
}
// --------------------
// Load Balancer
// --------------------
resource publicIpLb 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'lb-public-ip'
  location: location
  sku: { name: 'Basic' }
  properties: { publicIPAllocationMethod: 'Dynamic' }
}

module lb './modules/loadbalancer.bicep' = {
  name: 'lbDeploy'
  params: {
    lbName: 'myLoadBalancer'
    location: location
    publicIpId: publicIpLb.id
  }
}

module vm1 './modules/vm.bicep' = {
  name: 'vm1'
  params: {
    vmName: 'vm1'
    adminUsername: 'ljg'
    adminPassword: 'Minoandruby42!!!'
    location: location
    subnetId: vnet.properties.subnets[0].id
    nsgId: nsg.id
    backendPoolId: lb.outputs.backendPoolId
  }
}
module vm2 './modules/vm.bicep' = {
  name: 'vm2'
  params: {
    vmName: 'vm2'
    adminUsername: 'ljg'
    adminPassword: 'Minoandruby42!!!'
    location: location
    subnetId: vnet.properties.subnets[0].id
    nsgId: nsg.id
    backendPoolId: lb.outputs.backendPoolId
  }
}
