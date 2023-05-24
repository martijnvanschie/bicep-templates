@description('Specifies the location for all resources.')
param location string = 'westeurope'

param deployPeerings bool = false
param deployGateway bool = true

resource vnetHub 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: 'vnet-hub'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.1.0/27'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource vnetSpoke1 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: 'vnet-spoke-01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.1.0.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }  
}

resource vnetSpoke2 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: 'vnet-spoke-02'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.2.0.0/24'
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }  
}

resource hubToSpoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' = if(deployPeerings) {
  name: 'hubToSpoke1'
  parent: vnetHub
  properties: {
    remoteVirtualNetwork:{
      id: vnetSpoke1.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource spoke1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' = if(deployPeerings) {
  name: 'spoke1ToHub'
  parent: vnetSpoke1
  properties: {
    remoteVirtualNetwork:{
      id: vnetHub.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource hubToSpoke2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' = if(deployPeerings) {
  name: 'hubToSpoke2'
  parent: vnetHub
  properties: {
    remoteVirtualNetwork:{
      id: vnetSpoke2.id
    }    
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource spoke2ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' = if(deployPeerings) {
  name: 'spoke2ToHub'
  parent: vnetSpoke2
  properties: {
    remoteVirtualNetwork:{
      id: vnetHub.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

module virtualNetworkGateway 'modules/virtual-network-gateway.bicep' = if (deployGateway) {
  name: 'HubSpoke.Template.VirtualNetworkGateway'
  params: {
    vNetName: vnetHub.name
    location: location
  }
}

module vmSpoke1 'modules/virtual-machines.bicep' = {
  name: 'HubSpoke.Template.VirtualMachines.Spoke1'
  params: {
    location: location
    adminUsername: 'spoke1admin'
    adminPassword: '!Qwerty12345'
    subnetId: resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetSpoke1.name, 'default')
    vmName: 'spoke01'
  }
}

module vmSpoke2 'modules/virtual-machines.bicep' = {
  name: 'HubSpoke.Template.VirtualMachines.Spoke2'
  params: {
    location: location
    adminUsername: 'spoke2admin'
    adminPassword: '!Qwerty12345'
    subnetId: resourceId('Microsoft.Network/VirtualNetworks/subnets', vnetSpoke1.name, 'default')
    vmName: 'spoke02'
  }
}
