targetScope = 'resourceGroup'

@description('Specifies the location for all resources.')
param location string = 'westeurope'

@description('The name of the virtual machine. Will be prefixed with vm-')
param vmName string

@description('The id of the subnet for the network interface of this virtual machine.')
param subnetId string

@secure()
@description('The username for the admin account')
param adminUsername string

@secure()
@description('The password for the admin account')
param adminPassword string

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: 'nic-vm-${vmName}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: 'vm-${vmName}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'vm${vmName}'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        name: 'osd-vm-${vmName}'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}
