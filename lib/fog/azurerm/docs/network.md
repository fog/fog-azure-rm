# Network

This document explains how to get started using Azure Network Service with Fog. With this gem you can create/update/list/delete virtual networks, subnets, public IPs and network interfaces.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```
## Create Connection

Next, create a connection to the Network Service:

```ruby
    azure_network_service = Fog::Network::AzureRM.new(
        tenant_id: '<Tenantid>',                  # Tenant id of Azure Active Directory Application
        client_id:    '<Clientid>',               # Client id of Azure Active Directory Application
        client_secret: '<ClientSecret>',          # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'       # Subscription id of an Azure Account
)
```
## Create Virtual Network

Create a new virtual network

```ruby
    vnet = azure_network_service.virtual_networks.create(
        name: '<Virtual Network name>',
        location:         'westus',
        resource_group: '<Resource Group name>',
        subnet_address_list: '10.1.0.0/24',  
        dns_list: '10.1.0.5,10.1.0.6',
        network_address_list: '10.1.0.0/16,10.2.0.0/16'   
 )
```

## Check for Virtual Network

Checks if the Virtual Network already exists or not.

```ruby
    azure_network_service.virtual_networks.check_if_exists('<Virtual Network name>', '<Resource Group name>')
```

## List Virtual Networks

List all virtual networks in a subscription

```ruby
    vnets  = azure_network_service.virtual_networks
    vnets.each do |vnet|
        puts "#{vnet.name}"
        puts "#{vnet.location}"
    end
```

## Retrieve a single Virtual Network

Get a single record of virtual network

```ruby
      vnet = azure_network_service
                    .virtual_networks
                    .get('<Virtual Network name>', '<Resource Group name>')
        puts "#{vnet.name}"
```

## Destroy a single virtual network

Get virtual network object from the get method and then destroy that virtual network.

```ruby
      vnet.destroy
```

## Create Subnet

Create a new Subnet

```ruby
    subnet = azure_network_service.subnets.create(
        name: '<Subnet name>',
        resource_group: '<Resource Group name>',
        virtual_network_name: '<Virtual Network name>',
        address_prefix: '10.1.0.0/24'
    )   
 )
```

## List Subnets

List subnets in a resource group and a virtual network

```ruby
    subnets  = azure_network_service.subnets(resource_group: '<Resource Group name>', virtual_network_name: '<Virtual Network name>')
    subnets.each do |subnet|
        puts "#{subnet.name}"
    end
```

## Retrieve a single Subnet

Get a single record of Subnet

```ruby
      subnet = azure_network_service
                    .subnets(resource_group: '<Resource Group name>', virtual_network_name: '<Virtual Network name>')
                    .get('<Subnet name>')
        puts "#{subnet.name}"
```

## Destroy a single Subnet

Get a subnet object from the get method and then destroy that subnet.

```ruby
      subnet.destroy
```

## Create Network Interface

Create a new network interface. The parameter, private_ip_allocation_method can be Dynamic or Static.

```ruby
    nic = azure_network_service.network_interfaces.create(
        name: '<Network Interface name>',
        resource_group: '<Resource Group name>',
        location: 'eastus',
        subnet_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/virtualNetworks/<Virtual Network name>/subnets/<Subnet name>',
        ip_configuration_name: '<Ip Configuration Name>',
        private_ip_allocation_method: 'Dynamic'
 )
```

## List Network Interfaces

List network interfaces in a resource group

```ruby
    nics  = azure_network_service.network_interfaces(resource_group: '<Resource Group name>')
    nics.each do |nic|
        puts "#{nic.name}"
    end
```

## Retrieve a single Network Interface

Get a single record of Network Interface

```ruby
      nic = azure_network_service
                    .network_interfaces(resource_group: '<Resource Group name>')
                    .get('<Network Interface name>')
        puts "#{nic.name}"
```

## Destroy a single Network Interface

Get a network interface object from the get method and then destroy that network interface.

```ruby
      nic.destroy
```

## Create Public IP

Create a new public IP. The parameter, type can be Dynamic or Static.

```ruby
      pubip = azure_network_service.public_ips.create(
            name: '<Public IP name>',
            resource_group: '<Resource Group name>',
            location: 'westus',
            public_ip_allocation_method: 'Static'
      )
```

## Check for Public IP

Checks if the Public IP already exists or not.

```ruby
    azure_network_service.public_ips.check_if_exists('<Public IP name>', '<Resource Group name>')
```

## List Public IPs

List network interfaces in a resource group

```ruby
    pubips  = azure_network_service.public_ips(resource_group: '<Resource Group name>')
    pubips.each do |pubip|
        puts "#{pubip.name}"
    end
```

## Retrieve a single Public Ip

Get a single record of Public Ip

```ruby
      pubip = azure_network_service
                    .public_ips(resource_group: '<Resource Group name>')
                    .get('<Public IP name>')
        puts "#{pubip.name}"
```

## Destroy a single Public Ip

Get a Public IP object from the get method and then destroy that public IP.

```ruby
      pubip.destroy
```

## Create Load Balancer

Create a new load balancer.

```ruby
    lb = azure_network_service.load_balancers.create(
    name: '<Load Balancer name>',
    resource_group: '<Resource Group name>',
    location: 'westus',

    frontend_ip_configurations: 
                                [
                                    {
                                         #id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers/<Load Balancer name>/frontendIPConfigurations/fic',
                                         name: 'fic',
                                         private_ipallocation_method: 'Dynamic',
                                         # public_ipaddress_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/publicIPAddresses/pip',
                                         subnet_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sb1'
                                    }
                                ],
    backend_address_pool_names:
                                [
                                    'pool1'
                                ],
    load_balancing_rules:
                                [
                                    {
                                        name: 'lb_rule_1',
                                        frontend_ip_configuration_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers/<Load Balancer name>/frontendIPConfigurations/fic',
                                        backend_address_pool_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers/<Load Balancer name>/backendAddressPools/pool1',
                                        protocol: 'Tcp',
                                        frontend_port: '80',
                                        backend_port: '8080',
                                        enable_floating_ip: false,
                                        idle_timeout_in_minutes: 4,
                                        load_distribution: "Default"
                                    }
                                ],
    inbound_nat_rules: 
                                [
                                    {
                                        name: 'RDP-Traffic',
                                        frontend_ip_configuration_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers/<Load Balancer name>/frontendIPConfigurations/fic',
                                        protocol: 'Tcp',
                                        frontend_port: 3389,
                                        backend_port: 3389
                                    }
                                ]
)
```

## List Load Balancers

List all load balancers in a resource group

```ruby
    lbs = azure_network_service.load_balancers(resource_group: '<Resource Group name>')       
    lbs.each do |lb|
        puts "#{lb.name}"
    end
```

## Retrieve a single Load Balancer

Get a single record of Load Balancer

```ruby
    lb = azure_network_service
                  .load_balancers(resource_group: '<Resource Group name>')
                  .get('<Load Balancer name>')
    puts "#{lb.name}"
```

## Destroy a single Network Interface

Get a load balancer object from the get method and then destroy that load balancer.

```ruby
    lb.destroy
```

## Support and Feedback
Your feedback is highly appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
