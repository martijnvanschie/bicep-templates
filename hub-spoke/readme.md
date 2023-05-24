# Hub-spoke template

## Deployment

This template deploys a basic hub-spoke network topology in a specified resource group using Bicep. There are a few parameters which allow you to determine 

## Diagram

![Hub-spoke deployment](hub-spoke.png)

## Resources

- **Hub virtual network.** The hub virtual network hosts shared Azure services. Workloads hosted in the spoke virtual networks can use these services. The hub virtual network is the central point of connectivity for cross-premises networks.
- **Spoke virtual networks** Spoke virtual networks isolate and manage workloads separately in each spoke. Each workload can include multiple tiers, with multiple subnets connected through Azure load balancers. Spokes can exist in different subscriptions and represent different environments, such as Production and Non-production.
- **Network peerings**. *Optional*. The peerings are created between the hub and the spokes. This can be configured using Bicep parameters.
- **Virtual Network Gateway**. *Optional*. The Virtual Network Gateway is configured as a VPN device or service provides external connectivity to the cross-premises network. The VPN device can be a hardware device or a software solution such as the Routing and Remote Access Service (RRAS) in Windows Server.