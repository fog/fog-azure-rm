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

Optional parameters for Virtual Network: subnets, dns_servers & address_prefixes
Optional parameters for Subnet: network_security_group_id, route_table_id & address_prefix

```ruby
    vnet = azure_network_service.virtual_networks.create(
      name:             '<Virtual Network Name>',
      location:         'westus',
      resource_group:   '<Resource Group Name>',
      subnets:          [{
        name: '<Subnet Name>',
        address_prefix: '10.1.0.0/24',
        network_security_group_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/networkSecurityGroups/<Network Security Group Name>',
        route_table_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/routeTables/<Route Table Name>'
      }],
      dns_servers:       ['10.1.0.0','10.2.0.0'],
      address_prefixes:  ['10.1.0.0/16','10.2.0.0/16']
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
    vnets  = azure_network_service.virtual_networks(resource_group: '<Resource Group Name>')
    vnets.each do |vnet|
      puts "#{vnet.name}"
      puts "#{vnet.location}"
    end
```

## Retrieve a single Virtual Network

Get a single record of virtual network

```ruby
      vnet = azure_network_service
               .virtual_networks(resource_group: '<Resource Group Name>')
               .get('<Virtual Network name>')
      puts "#{vnet.name}"
```

## Destroy a single virtual network

Get virtual network object from the get method and then destroy that virtual network.

```ruby
    vnet.destroy
```

## Create Subnet

Create a new Subnet

Optional parameters: network_security_group_id, route_table_id & address_prefix

```ruby
    subnet = azure_network_service.subnets.create(
      name: '<Subnet Name>',
      resource_group: '<Resource Group Name>',
      virtual_network_name: '<Virtual Network Name>',
      address_prefix: '10.0.0.0/24',
      network_security_group_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/networkSecurityGroups/<Network Security Group Name>',
      route_table_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/routeTables/<Route Table Name>'
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

## Attach Network Security Group to Subnet

Attach Network Security Group to Subnet

```ruby
     subnet = azure_network_service.attach_network_security_group('/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/networkSecurityGroups/<Network Security Group Name>')
     puts "#{subnet.network_security_group_id}"
```

## Detach Network Security Group from Subnet

Detach Network Security Group from Subnet

```ruby
     subnet = azure_network_service.detach_network_security_group
     puts "#{subnet.network_security_group_id}"
```

## Attach Route Table to Subnet

Attach Route Table to Subnet

```ruby
     subnet = azure_network_service.attach_route_table('/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/routeTables/<Route Table Name>')
     puts "#{subnet.route_table_id}"
```

## Detach Route Table from Subnet

Detach Route Table from Subnet

```ruby
     subnet = azure_network_service.detach_route_table
     puts "#{subnet.route_table_id}"
```

## Destroy a single Subnet

Get a subnet object from the get method and then destroy that subnet.

```ruby
    subnet.destroy
```

## Create Network Interface

Create a new network interface. Skip public_ip_address_id parameter to create network interface without PublicIP. The parameter, private_ip_allocation_method can be Dynamic or Static.

```ruby
    nic = azure_network_service.network_interfaces.create(
      name: '<Network Interface name>',
      resource_group: '<Resource Group name>',
      location: 'eastus',
      subnet_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/virtualNetworks/<Virtual Network name>/subnets/<Subnet name>',
      public_ip_address_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/publicIPAddresses/<Public IP name>',
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

## Create Network Security Group

Network security group requires a resource group to create. 

```ruby
     azure_network_service.network_security_groups.create(
       name: '<Network Security Group name>',
       resource_group: '<Resource Group name>',
       location: 'eastus',
       security_rules: [{
         name: '<Security Rule name>',
         protocol: 'tcp',
         source_port_range: '22',
         destination_port_range: '22',
         source_address_prefix: '0.0.0.0/0',
         destination_address_prefix: '0.0.0.0/0',
         access: 'Allow',
         priority: '100',
         direction: 'Inbound'
       }]
     )
```

## List Network Security Groups 

List all the network security groups in a resource group

```ruby
    network_security_groups = azure_network_service.network_security_groups(resource_group: '<Resource Group name>')       
    network_security_groups.each do |nsg|
      puts "#{nsg.name}"
    end
```

## Retrieve a single Network Security Group

Get a single record of Network Security Group

```ruby
    nsg = azure_network_service
          .network_security_groups(resource_group: '<Resource Group name>')
          .get('<Network Security Group name>')
    puts "#{nsg.name}"
```

## Destroy a Network Security Group

Get a network security group object from the get method and then destroy that network security group.

```ruby
    nsg.destroy
```

## Create External Load Balancer

Create a new load balancer.

```ruby
    lb = azure_network_service.load_balancers.create(
    name: '<Load Balancer name>',
    resource_group: '<Resource Group name>',
    location: 'westus',

    frontend_ip_configurations: 
                                [
                                    {                                         
                                         name: 'fic',
                                         private_ipallocation_method: 'Dynamic',
                                         public_ipaddress_id: '/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/publicIPAddresses/<Public-IP-Name>'                                         
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

## Create Internal Load Balancer

```ruby

    lb = azure_network_service.load_balancers.create(
    name: '<Load Balancer name>',
    resource_group: '<Resource Group name>',
    location: 'westus',
    frontend_ip_configurations:
        [
        {
            name: 'LB-Frontend',
            private_ipallocation_method: 'Static',
            private_ipaddress: '10.1.2.5',
            subnet_id: subnet.id
        }
        ],
    backend_address_pool_names:
        [
        'LB-backend'
        ],
    load_balancing_rules:
        [
        {
            name: 'HTTP',
            frontend_ip_configuration_id: "/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers/<Load-Balancer-Name>/frontendIPConfigurations/LB-Frontend",
            backend_address_pool_id: "/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers/<Load-Balancer-Name>/backendAddressPools/LB-backend",
            probe_id: "/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers<Load-Balancer-Name>lb/probes/HealthProbe",
            protocol: 'Tcp',
            frontend_port: '80',
            backend_port: '80'
        }
        ],
    inbound_nat_rules:
        [
        {
            name: 'RDP1',
            frontend_ip_configuration_id: "/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers/<Load-Balancer-Name>/frontendIPConfigurations/LB-Frontend",
            protocol: 'Tcp',
            frontend_port: 3441,
            backend_port: 3389
        },
        {
            name: 'RDP2',
            frontend_ip_configuration_id: "/subscriptions/<Subscriptionid>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/loadBalancers/<Load-Balancer-Name>/frontendIPConfigurations/LB-Frontend",
            protocol: 'Tcp',
            frontend_port: 3442,
            backend_port: 3389
        }
        ],
    probes:
        [
        {
            name: 'HealthProbe',
            protocol: 'http',
            request_path: 'HealthProbe.aspx',
            port: '80',
            interval_in_seconds: 15,
            number_of_probes: 2
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

## Destroy a Load Balancer

Get a load balancer object from the get method and then destroy that load balancer.

```ruby
    lb.destroy
```

## Create Traffic Manager Profile

Create a new Traffic Manager Profile. The parameter, traffic_routing_method can be Performance, Weighted or Priority.

```ruby
      profile = azure_network_service.traffic_manager_profiles.create(
        name: '<Profile Name>',
        resource_group: '<Resource Group Name>',
        traffic_routing_method: 'Performance',
        relative_name: '<Profile Relative Name>',
        ttl: '30',
        protocol: 'http',
        port: '80',
        path: '/monitorpage.aspx'
      )
```

## List Traffic Manager Profiles

List Traffic Manager Profiles in a resource group

```ruby
    profiles  = azure_network_service.traffic_manager_profiles(resource_group: '<Resource Group name>')
    profiles.each do |profile|
      puts "#{profile.name}"
    end
```

## Retrieve a single Traffic Manager Profile

Get a single record of Traffic Manager Profile

```ruby
     profile = azure_network_service
               .traffic_manager_profiles(resource_group: '<Resource Group name>')
                .get('<Profile name>')
     puts "#{profile.name}"
```

## Destroy a single Traffic Manager Profile

Get a Traffic Manager Profile object from the get method and then destroy that Traffic Manager Profile.

```ruby
     profile.destroy
```

## Create Traffic Manager Endpoint

Create a new Traffic Manager Endpoint. The parameter, type can be external, azure or nested.

```ruby
      profile = azure_network_service.traffic_manager_end_points.create(
        name: '<Endpoint Name>',
        traffic_manager_profile_name: '<Profile Name>',
        resource_group: '<Resource Group Name>',
        type: 'external',
        target: 'test.com',
        endpoint_location: 'West US'
      )
```

## List Traffic Manager Endpoints

List Traffic Manager Endpoints in a resource group

```ruby
    endpoints  = azure_network_service.traffic_manager_end_points(resource_group: '<Resource Group name>', traffic_manager_profile_name: '<Profile Name>')
    endpoints.each do |endpoint|
      puts "#{endpoint.name}"
    end
```

## Retrieve a single Traffic Manager Endpoint

Get a single record of Traffic Manager Endpoint

```ruby
      endpoint = azure_network_service
                 .traffic_manager_end_points(resource_group: '<Resource Group name>', traffic_manager_profile_name: '<Profile Name>')
                 .get('<Endpoint name>')
      puts "#{endpoint.name}"
```

## Destroy a single Traffic Manager Endpoint

Get a Traffic Manager Endpoint object from the get method and then destroy that Traffic Manager Endpoint.

```ruby
     endpoint.destroy
```

## Create Application Gateway

Create a new Application Gateway.

```ruby
    gateway = azure_network_service.application_gateways.create(
        name: '<Gateway Name>',
        location: 'eastus',
        resource_group: '<Resource Group name>',
        sku_name: 'Standard_Medium',
        sku_tier: 'Standard',
        sku_capacity: '2',
        gateway_ip_configurations:
            [
                {
                    name: 'gatewayIpConfigName',
                    subnet_id: '/subscriptions/<Subscription_id>/resourcegroups/<Resource Group name>/providers/Microsoft.Network/virtualNetworks/<Virtual Network Name>/subnets/<Subnet Name>'
                }
            ],
        frontend_ip_configurations:
            [
                {
                    name: 'frontendIpConfig',
                    private_ip_allocation_method: 'Dynamic',
                    public_ip_address_id: '/subscriptions/<Subscription_id>/resourcegroups/<Resource Group name>/providers/Microsoft.Network/publicIPAddresses/<Public IP Address Name>',
                    private_ip_address: '10.0.1.5'
                }
            ],
        frontend_ports:
            [
                {
                    name: 'frontendPort',
                    port: 443
                }
            ],
        backend_address_pools:
            [
                {
                    name: 'backendAddressPool',
                    ip_addresses: [
                        {
                            ipAddress: '10.0.1.6'
                        }
                    ]
                }
            ],
        backend_http_settings_list:
            [
                {
                    name: 'gateway_settings',
                    port: 80,
                    protocol: 'Http',
                    cookie_based_affinity: 'Enabled',
                    request_timeout: '30'
                }
            ],
        http_listeners:
            [
                {
                    name: 'gateway_listener',
                    frontend_ip_config_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/frontendIPConfigurations/frontendIpConfig',
                    frontend_port_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/frontendPorts/frontendPort',
                    protocol: 'Http',
                    host_name: '',
                    require_server_name_indication: 'false'
                }
            ],
        request_routing_rules:
            [
                {
                    name: 'gateway_request_route_rule',
                    type: 'Basic',
                    http_listener_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/httpListeners/gateway_listener',
                    backend_address_pool_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/backendAddressPools/backendAddressPool',
                    backend_http_settings_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/backendHttpSettingsCollection/gateway_settings',
                    url_path_map: ''
                }
            ]


    )
```

## List Application Gateways

List all application gateways in a resource group

```ruby
    gateways = azure_network_service.application_gateways(resource_group: '<Resource Group Name>')
    gateways.each do |gateway|
        puts "#{gateway.name}"
    end
```

## Retrieve a single Application Gateway

Get a single record of Application Gateway

```ruby
    gateway = azure_network_service
                            .application_gateways(resource_group: '<Resource Group name>')
                            .get('<Application Gateway Name>')
    puts "#{gateway.name}"
```

## Destroy a single Application Gateway

Get a application gateway object from the get method and then destroy that application gateway.

```ruby
    gateway.destroy
```

## Support and Feedback
Your feedback is highly appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
