targetScope = 'resourceGroup'

@description('Specifies the location for all resources.')
param location string = 'westeurope'

// @description('The subnet id where the VPN Gateway needs to be deployed.')
// param subnetId string

param vNetName string

var gatewaySubnetName = 'GatewaySubnet'
var vpnGatewayIpName = 'pip-vpn-gateway'
var vpnGatewayName = 'vgw-Default-Test'

resource subGateway 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' existing = {
  name: '${vNetName}/${gatewaySubnetName}'
}

resource vpnGatewayPip 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: vpnGatewayIpName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
}

//resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2022-09-01' = if (resourceId('Microsoft.Network/virtualNetworkGateways', vpnGatewayName) == null)  {
resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2022-09-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    gatewayType: 'Vpn'
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subGateway.id
          }
          publicIPAddress: {
            id: vpnGatewayPip.id
          }
        }
      }
    ]
    vpnType: 'RouteBased'
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
  }
}
