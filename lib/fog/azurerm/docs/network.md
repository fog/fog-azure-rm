# Network

This document explains how to get started using Azure Network Service with Fog. With this gem you can create, update, list or delete virtual networks, subnets, public IPs and network interfaces.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```
## Create Connection

Next, create a connection to the Network Service:

```ruby
fog_network_service = Fog::Network::AzureRM.new(
        tenant_id: '<Tenant Id>',                                                             # Tenant Id of Azure Active Directory Application
        client_id:    '<Client Id>',                                                          # Client Id of Azure Active Directory Application
        client_secret: '<Client Secret>',                                                     # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscription Id>',                                                 # Subscription Id of an Azure Account
        environment: '<AzureCloud/AzureChinaCloud/AzureUSGovernment/AzureGermanCloud>'        # Azure cloud environment. Default is AzureCloud.
)
```

## Check Virtual Network Existence

```ruby
 fog_network_service.virtual_networks.check_virtual_network_exists('<Resource Group Name>', '<Virtual Network Name>')
```

## Create Virtual Network

Create a new virtual network

**Optional parameters for Virtual Network**: subnets, dns_servers & address_prefixes

**Optional parameters for Subnet**: network_security_group_id, route_table_id & address_prefix

```ruby
vnet = fog_network_service.virtual_networks.create(
      name:             '<Virtual Network Name>',
      location:         '<Location>',
      resource_group:   '<Resource Group Name>',
      subnets:          [{
        name: '<Subnet Name>',
        address_prefix: '<Subnet IP Range>',
        network_security_group_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/networkSecurityGroups/<Network Security Group Name>',
        route_table_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/routeTables/<Route Table Name>'
      }],
      dns_servers:       ['<IP Address>','<IP Address>'],
      address_prefixes:  ['<IP Address Range>','<IP Address Range>'],
      tags: { key: 'value' }            # [Optional]
)
```

## List Virtual Networks in Resource Group

List all virtual networks in a resource group

```ruby
vnets  = fog_network_service.virtual_networks(resource_group: '<Resource Group Name>')
vnets.each do |vnet|
      puts "#{vnet.name}"
      puts "#{vnet.location}"
end
```

## List Virtual Networks in Subscription

List all virtual networks in a subscription

```ruby
vnets  = fog_network_service.virtual_networks
vnets.each do |vnet|
      puts "#{vnet.name}"
      puts "#{vnet.location}"
end
```

## Retrieve a single Virtual Network

Get a single record of virtual network

```ruby
vnet = fog_network_service.virtual_networks.get('<Resource Group Name>', '<Virtual Network Name>')
puts "#{vnet.name}"
```

## Add/Remove DNS Servers to/from Virtual Network

Add/Remove DNS Servers to/from Virtual Network

```ruby
vnet.add_dns_servers(['<IP Address>','<IP Address>'])
vnet.remove_dns_servers(['10.3.0.0','10.4.0.0'])
```

## Add/Remove Address Prefixes to/from Virtual Network

Add/Remove Address Prefixes to/from Virtual Network

```ruby
vnet.add_address_prefixes(['<IP Address Range>', '<IP Address Range>'])
vnet.remove_address_prefixes(['<IP Address Range>'])
```

## Add/Remove Subnets to/from Virtual Network

Add/Remove Subnets to/from Virtual Network

```ruby
vnet.add_subnets([{
       name: '<Subnet Name>',
       address_prefix: '<Subnet Range>'
}])

vnet.remove_subnets(['<Subnet Name>'])
```

## Update Virtual Network

Update Virtual Network

```ruby
vnet.update({
       subnets:[{
          name: '<Subnet Name>',
          address_prefix: '<Subnet Range>'
       }],
       dns_servers: ['<IP Address>','<IP Address>']
})
```

## Destroy a single virtual network

Get virtual network object from the get method and then destroy that virtual network.

```ruby
vnet.destroy
```

## Check Subnet Existence

```ruby
fog_network_service.subnets.check_subnet_exists('<Resource Group Name>', '<Virtual Network Name>', '<Subnet Name>')
```

## Create Subnet

Create a new Subnet

Optional parameters: network_security_group_id, route_table_id & address_prefix

```ruby
subnet = fog_network_service.subnets.create(
      name: '<Subnet Name>',
      resource_group: '<Resource Group Name>',
      virtual_network_name: '<Virtual Network Name>',
      address_prefix: '<Subnet Range>',
      network_security_group_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/networkSecurityGroups/<Network Security Group Name>',
      route_table_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/routeTables/<Route Table Name>'
)
```

## List Subnets

List subnets in a resource group and a virtual network

```ruby
subnets  = fog_network_service.subnets(resource_group: '<Resource Group Name>', virtual_network_name: '<Virtual Network Name>')
subnets.each do |subnet|
      puts "#{subnet.name}"
end
```

## Retrieve a single Subnet

Get a single record of Subnet

```ruby
subnet = fog_network_service
            .subnets
            .get('<Resource Group Name>', '<Virtual Network Name>', '<Subnet Name>')
puts "#{subnet.name}"
```

## Attach Network Security Group to Subnet

Attach Network Security Group to Subnet

```ruby
subnet = fog_network_service.attach_network_security_group('/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/networkSecurityGroups/<Network Security Group Name>')
puts "#{subnet.network_security_group_id}"
```

## Detach Network Security Group from Subnet

Detach Network Security Group from Subnet

```ruby
subnet = fog_network_service.detach_network_security_group
puts "#{subnet.network_security_group_id}"
```

## Attach Route Table to Subnet

Attach Route Table to Subnet

```ruby
subnet = fog_network_service.attach_route_table('/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/routeTables/<Route Table Name>')
puts "#{subnet.route_table_id}"
```

## Detach Route Table from Subnet

Detach Route Table from Subnet

```ruby
subnet = fog_network_service.detach_route_table
puts "#{subnet.route_table_id}"
```

## List Number of Available IP Addresses in Subnet

The parameter is a boolean which checks if the Virtual Network the Subnet belongs to is attached to an Express Route Circuit or not

```ruby
puts "#{subnet.get_available_ipaddresses_count(<True/False>)}"
```

## Destroy a single Subnet

Get a subnet object from the get method and then destroy that subnet.

```ruby
subnet.destroy
```

## Check Network Interface Card Existence

```ruby
fog_network_service.network_interfaces.check_network_interface_exists('<Resource Group Name>', '<Network Interface Name>')
```

## Create Network Interface Card

Create a new network interface. Skip public_ip_address_id parameter to create network interface without PublicIP. The parameter, private_ip_allocation_method can be Dynamic or Static.

```ruby
nic = fog_network_service.network_interfaces.create(
      name: '<Network Interface Name>',
      resource_group: '<Resource Group Name>',
      location: '<Location>',
      subnet_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/virtualNetworks/<Virtual Network Name>/subnets/<Subnet Name>',
      public_ip_address_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/publicIPAddresses/<Public IP Name>',
      ip_configuration_name: '<IP Configuration Name>',
      private_ip_allocation_method: '<IP Allocation Method Name>',
      tags: { key: 'value' }                    # [Optional],
      enable_accelerated_networking: true       # [Optional] false by default
)
```

## Create Network Interface Card Asynchronously

Create a new network interface asynchronously. Skip public_ip_address_id parameter to create network interface without PublicIP. The parameter, private_ip_allocation_method can be Dynamic or Static.

```ruby
nic = fog_network_service.network_interfaces.create_async(
      name: '<Network Interface Name>',
      resource_group: '<Resource Group Name>',
      location: '<Location>',
      subnet_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/virtualNetworks/<Virtual Network Name>/subnets/<Subnet Name>',
      public_ip_address_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/publicIPAddresses/<Public IP Name>',
      ip_configuration_name: '<IP Configuration Name>',
      private_ip_allocation_method: '<IP Allocation Method Name>',
      tags: { key: 'value' }                    # [Optional],
      enable_accelerated_networking: true       # [Optional] false by default
)
```

## List Network Interface Cards

List network interfaces in a resource group

```ruby
nics  = fog_network_service.network_interfaces(resource_group: '<Resource Group Name>')
nics.each do |nic|
      puts "#{nic.name}"
end
```

## Retrieve a single Network Interface Card

Get a single record of Network Interface

```ruby
nic = fog_network_service
           .network_interfaces
           .get('<Resource Group Name>', '<Network Interface Name>')
puts "#{nic.name}"
```

## Update Network Interface Card

You can update network interface by passing only updated attributes, in the form of hash.
For example,
```ruby
nic.update(private_ip_allocation_method: '<IP Allocation Method Name>', private_ip_address: '<Private IP Address>')
```
## Attach/Detach resources to Network Interface Card

Attach Subnet, Public-IP or Network-Security-Group as following
```ruby
subnet_id = '<Subnet Id>'
nic.attach_subnet(subnet_id)
    
public_ip_id = '<Public IP Id>'
nic.attach_public_ip(public_ip_id)
    
nsg_id = '<NSG Id>'
nic.attach_network_security_group(nsg_id)
```
Detach Public-IP or Network-Security-Group as following

```ruby 
nic.detach_public_ip

nic.detach_network_security_group
```
`Note: You can't detach subnet from Network Interface.`

## Destroy a single Network Interface Card

Get a network interface object from the get method and then destroy that network interface.

```ruby
nic.destroy
```

## Check Public IP Existence

```ruby
fog_network_service.public_ips.check_public_ip_exists('<Resource Group Name>', '<Public IP Name>')
```

## Create Public IP

Create a new public IP. The parameter, type can be Dynamic or Static.

```ruby
public_ip = fog_network_service.public_ips.create(
     name: '<Public IP name>',
     resource_group: '<Resource Group Name>',
     location: '<Location>',
     public_ip_allocation_method: '<IP Allocation Method Name>',
     tags: { key: 'value' }                 # [Optional]
)
```

## Check for Public IP

Checks if the Public IP already exists or not.

```ruby
fog_network_service.public_ips.check_if_exists('<Public IP Name>', '<Resource Group Name>')
```

## List Public IPs

List network interfaces in a resource group

```ruby
public_ips  = fog_network_service.public_ips(resource_group: '<Resource Group Name>')
public_ips.each do |pubip|
      puts "#{public_ip.name}"
end
```

## Retrieve a single Public IP

Get a single record of Public IP

```ruby
public_ip = fog_network_service
             .public_ips
             .get('<Resource Group Name>', '<Public IP Name>')
puts "#{public_ip.name}"
```

## Update Public IP

Get a Public IP object from the get method and then update that public IP. You can update the Public IP by passing the modifiable attributes in the form of a hash.

```ruby
public_ip.update(
      public_ip_allocation_method: '<IP Allocation Method Name>',
      idle_timeout_in_minutes: '<Idle Timeout in Minutes>',
      domain_name_label: '<Domain Name Label>'
)
```

## Destroy a single Public IP

Get a Public IP object from the get method and then destroy that public IP.

```ruby
public_ip.destroy
```

## Check Network Security Group Existence

```ruby
fog_network_service.network_security_groups.check_net_sec_group_exists('<Resource Group Name>', '<Network Security Group Name>')
```

## Create Network Security Group

Network security group requires a resource group to create. 

```ruby
fog_network_service.network_security_groups.create(
       name: '<Network Security Group Name>',
       resource_group: '<Resource Group Name>',
       location: '<Location>',
       security_rules: [{
            name: '<Security Rule Name>',
            protocol: '<Protocol Name>',
            source_port_range: '<Source Port Range>',
            destination_port_range: '<Destination Port Range>',
            source_address_prefix: '<Source IP Address Range>',
            destination_address_prefix: 'Destination IP Address Range',
            access: '<Security Rule Access Type>',
            priority: '<Priority Number>',
            direction: '<Security Rule Direction>'
       }],
       tags: { key: 'value' }                   # [Optional]
)
```

## List Network Security Groups 

List all the network security groups in a resource group

```ruby
network_security_groups = fog_network_service.network_security_groups(resource_group: '<Resource Group Name>')       
network_security_groups.each do |nsg|
      puts "#{nsg.name}"
end
```

## Retrieve a single Network Security Group

Get a single record of Network Security Group

```ruby
nsg = fog_network_service
                  .network_security_groups
                  .get('<Resource Group Name>','<Network Security Group Name>')
puts "#{nsg.name}"
```

## Update Security Rules

You can update security rules by passing the modified attributes in the form of hash.  

```ruby
nsg.update_security_rules(
        security_rules:
        [
                {
                    name: '<Security Rule Name>',
                    protocol: '<Security Rule Protocol>',
                    source_port_range: '<Port Range>',
                    destination_port_range: '<Port Range>',
                    source_address_prefix: '<Source IP Address Range>',
                    destination_address_prefix: '<Destination IP Address Range>',
                    access: '<Security Rule Access Type>',
                    priority: '<Priority Number>',
                    direction: '<Security Rule Direction>'
                }
        ]
)
```
`Note: You can't modify Name of a security rule.`

## Add and Remove Security Rules in a Network Security Group

Add array of security rules in the form of hash.

```ruby
nsg.add_security_rules(
           [
                {
                    name: '<Security Rule Name>',
                    protocol: '<Security Rule Protocol>',
                    source_port_range: '<Port Range>',
                    destination_port_range: '<Port Range>',
                    source_address_prefix: '<Source IP Address Range>',
                    destination_address_prefix: '<Destination IP Address Range>',
                    access: '<Security Rule Access Type>',
                    priority: '<Priority Number>',
                    direction: '<Security Rule Direction>'
                }
           ]
)
```

Delete security rule by providing its name.

```ruby
nsg.remove_security_rule('<Security Rule Name>')
```

## Destroy a Network Security Group

Get a network security group object from the get method and then destroy that network security group.

```ruby
nsg.destroy
```

## Check Network Security Rule Existence

```ruby
fog_network_service.network_security_rules.check_net_sec_rule_exists('<Resource Group Name>', '<Network Security Group Name>', '<Security Rule Name>')
```

## Create Network Security Rule

Network security rule requires a resource group and network security group to create. 

```ruby
fog_network_service.network_security_rules.create(
       name: '<Security Rule Name>',
       resource_group: '<Resource Group Name>',
       protocol: '<Security Rule Protocol>',
       network_security_group_name: '<Network Security Group Name>',
       source_port_range: '<Source Port Range>',
       destination_port_range: '<Destination Port Range>',
       source_address_prefix: 'Source IP Address Range',
       destination_address_prefix: 'Destination IP Address Range',
       access: '<Security Rule Access Type>',
       priority: '<Priority Number>',
       direction: '<Security Rule Direction>'
)
```

## List Network Security Rules 

List all the network security rules in a resource group and network security group

```ruby
network_security_rules = fog_network_service.network_security_rules(resource_group: '<Resource Group Name>', network_security_group_name: '<Network Security Group Name>')
network_security_rules.each do |network_security_rule|
      puts network_security_rule.name
end
```

## Retrieve a single Network Security Rule

Get a single record of Network Security Rule

```ruby
network_security_rule = fog_network_service
                  .network_security_rules
                  .get('<Resource Group Name>','<Network Security Group Name>', '<Security Rule Name>')
puts "#{network_security_rule.name}"              
```

## Destroy a Network Security Rule

Get a network security rule object from the get method and then destroy that network security rule.

```ruby
network_security_rule.destroy
```

## Check External Load Balancer Existence

```ruby
fog_network_service.load_balancers.check_load_balancer_exists('<Resource Group Name>', '<Load Balancer Name>')
```

## Create External Load Balancer

Create a new load balancer.

```ruby
lb = fog_network_service.load_balancers.create(
        name: '<Load Balancer Name>',
        resource_group: '<Resource Group Name>',
        location: '<Location>',
        frontend_ip_configurations: 
                                [
                                    {                                         
                                         name: '<Frontend IP Config Name>',
                                         private_ipallocation_method: '<Private IP Allocation Method>',
                                         public_ipaddress_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/publicIPAddresses/<Public IP Name>'                                         
                                    }
                                ],
        backend_address_pool_names:
                                [
                                    '<Backend Address Pool Name>'
                                ],
        load_balancing_rules:
                                [
                                    {
                                        name: '<Rule Name>',
                                        frontend_ip_configuration_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/loadBalancers/<Load Balancer Name>/frontendIPConfigurations/<Frontend IP Config Name>',
                                        backend_address_pool_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/loadBalancers/<Load Balancer Name>/backendAddressPools/<Backend Address Pool Name>',
                                        protocol: '<Protocol Name>',
                                        frontend_port: '<Frontend Port Number>',
                                        backend_port: '<Backend Port Number>',
                                        enable_floating_ip: <True/False>,
                                        idle_timeout_in_minutes: <Timeout in Minutes>,
                                        load_distribution: '<Load Distribution Value>'
                                    }
                                ],
        inbound_nat_rules: 
                                [
                                    {
                                        name: 'NAT Rule Name',
                                        frontend_ip_configuration_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/loadBalancers/<Load Balancer name>/frontendIPConfigurations/<Frontend IP Config Name>',
                                        protocol: '<Protocol Name>',
                                        frontend_port: '<Frontend Port Number>',
                                        backend_port: '<Backend Port Number>'
                                    }
                                ],
        tags: { key: 'value' }                  # [Optional]
)
```

## Create Internal Load Balancer

```ruby
lb = fog_network_service.load_balancers.create(
    name: '<Load Balancer Name>',
    resource_group: '<Resource Group Name>',
    location: '<Location>',
    frontend_ip_configurations:
        [
             {
                 name: '<Frontend IP Config Name>',
                 private_ipallocation_method: '<Private IP Allocation Method>',
                 private_ipaddress: 'IP Address',
                 subnet_id: '<Subnet Id>'
             }
        ],
    backend_address_pool_names:
        [
             '<Backend Address Pool Name>'
        ],
    load_balancing_rules:
        [
            {
                 name: 'Rule Name',
                 frontend_ip_configuration_id: "/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/loadBalancers/<Load Balancer Name>/frontendIPConfigurations/<Frontend IP Config Name>",
                 backend_address_pool_id: "/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/loadBalancers/<Load Balancer Name>/backendAddressPools/<Backend Address Pool Name>",
                 probe_id: "/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/loadBalancers<Load Balancer Name>lb/probes/<Probe Name>",
                 protocol: '<Protocol Name>',
                 frontend_port: '<Frontend Port Number>',
                 backend_port: '<Backend Port Number>'
            }
        ],
    inbound_nat_rules:
        [
            {
                 name: '<Rule Name>',
                 frontend_ip_configuration_id: "/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/loadBalancers/<Load Balancer Name>/frontendIPConfigurations/<Frontend IP Config Name>",
                 protocol: '<Protocol Name>',
                 frontend_port: '<Frontend Port Number>',
                 backend_port: '<Backend Port Number>'
            },

            {
                 name: '<Rule Name>',
                 frontend_ip_configuration_id: "/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/loadBalancers/<Load Balancer Name>/frontendIPConfigurations/<Frontend IP Config Name>",
                 protocol: '<Protocol Name>',
                 frontend_port: '<Frontend Port Number>',
                 backend_port: '<Backend Port Number>'
            }
        ],
    probes:
        [
        {
            name: '<Probe Name>',
            protocol: '<Protocol Name>',
            request_path: '<Probe Request Path>',
            port: '<Port Number>',
            interval_in_seconds: <Interval in Seconds>,
            number_of_probes: <Number of Probes>
        }
        ],
    tags: { key: 'value' }                  # [Optional]
)
```

## List Load Balancers

List all load balancers in a resource group

```ruby
lbs = fog_network_service.load_balancers(resource_group: '<Resource Group Name>')       
lbs.each do |lb|
      puts "#{lb.name}"
end
```

## List Load Balancers in subscription

List all load balancers in a subscription

```ruby
lbs = fog_network_service.load_balancers
lbs.each do |lb|
      puts "#{lb.name}"
end
```

## Retrieve a single Load Balancer

Get a single record of Load Balancer

```ruby
lb = fog_network_service
         .load_balancers
         .get('<Resource Group Name>', '<Load Balancer Name>')
puts "#{lb.name}"
```

## Destroy a Load Balancer

Get a load balancer object from the get method and then destroy that load balancer.

```ruby
lb.destroy
```

## Check Virtual Network Gateway Existence

```ruby
fog_network_service.virtual_network_gateways.check_vnet_gateway_exists('<Resource Group Name>', '<Virtual Network Gateway Name>')
```

## Create Virtual Network Gateway

Create a new Virtual Network Gateway.

```ruby
network_gateway = network.virtual_network_gateways.create(
      name: '<Virtual Network Gateway Name>',
      location: '<Location>',
      ip_configurations: [
        {
          name: '<IP Config Name>',
          private_ipallocation_method:'<Private IP Allocation Method>',
          public_ipaddress_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/publicIPAddresses/<Public IP Name>',
          subnet_id: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/virtualNetworks/<Virtual Network Name>/subnets/<Subnet Name>',
          private_ipaddress: <IP Address Value>         # could be 'nil'
        }
      ],
      resource_group: '<Resource Group Name>',
      sku_name: '<SKU Name>',
      sku_tier: '<SKU Tier>',
      sku_capacity: <SKU Capacity>,
      gateway_type: '<Gateway Type>',
      enable_bgp: <True/False>,
      gateway_size: <Gateway Size>,
      asn: <ASN Value>,
      bgp_peering_address: <Peering Address>,
      peer_weight: <Peer Weight>,
      vpn_type: '<VPN Type>',
      vpn_client_address_pool: [],
      gateway_default_site: '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/localNetworkGateways/<Local Network Gateway Name>',
      default_sites: [],
      vpn_client_configuration: {
        address_pool: ['<IP Address>', '<IP Address>'],
        root_certificates: [
          {
            name: '<Certificate Name>',
            public_cert_data: '<Certificate Data>'
          }
        ],
        revoked_certificates: [
          {
            name: '<Certificate Name>',
            thumbprint: '<Thumb Print Detail>'
          }
        ]
      },
      tags: {                   # [Optional]
           key1: 'value1',
           key2: 'value2'
      }
    )
```

## List Virtual Network Gateways

List all virtual network gateways in a resource group

```ruby
network_gateways = network.virtual_network_gateways(resource_group: '<Resource Group Name>')
network_gateways.each do |gateway|
    	puts "#{gateway.name}"
end
```

## Retrieve single Virtual Network Gateway

Get single record of Virtual Network Gateway

```ruby
network_gateway = network.virtual_network_gateways.get('<Resource Group Name>', '<Virtual Network Gateway Name>')
puts "#{network_gateway.name}"
```

## Destroy single Virtual Network Gateway

Get a virtual network gateway object from the get method and then destroy that virtual network gateway.

```ruby
network_gateway.destroy
```

## Check Local Network Gateway Existence

```ruby
fog_network_service.local_network_gateways.check_local_net_gateway_exists('<Resource Group Name>', '<Local Network Gateway Name>')
```

## Create Local Network Gateway

Create a new Local Network Gateway.

```ruby
local_network_gateway = network.local_network_gateways.create(
        name: "<Local Network Gateway Name>",
        location: '<Location>',
        resource_group: "<Resource Group Name>",
        gateway_ip_address: '<IP Address>',
        local_network_address_space_prefixes: [],
        asn: <ASN Value>,
        bgp_peering_address: '<Peering IP Address>',
        peer_weight: <Peer Weight>,
        tags: {                     # [Optional]
                key1: 'value1',
                key2: 'value2'
        },
)
```

## List Local Network Gateways

List all local network gateways in a resource group

```ruby
local_network_gateways = network.local_network_gateways(resource_group: '<Resource Group Name>')
local_network_gateways.each do |gateway|
    	puts "#{gateway.name}"
end
```

## Retrieve single Local Network Gateway

Get single record of Local Network Gateway

```ruby
local_network_gateway = network.local_network_gateways.get('<Resource Group Name>', '<Local Network Gateway Name>')
puts "#{local_network_gateway.name}"
```

## Destroy single Local Network Gateway

Get a local network gateway object from the get method and then destroy that local network gateway.

```ruby
local_network_gateway.destroy
```

# Express Route

Microsoft Azure ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a dedicated private connection facilitated by a connectivity provider.
For more details about express route [click here](https://azure.microsoft.com/en-us/documentation/articles/expressroute-introduction/).

# Express Route Circuit

The Circuit represents the entity created by customer to register with an express route service provider with intent to connect to Microsoft.

## Check Express Route Circuit Existence

```ruby
fog_network_service.express_route_circuits.check_express_route_circuit_exists('<Resource Group Name>', '<Circuit Name>')
```

## Create an Express Route Circuit

Create a new Express Route Circuit.

```ruby
circuit = network.express_route_circuits.create(
    	name: '<Circuit Name>',
    	location: '<Location>',
    	resource_group: '<Resource Group Name>',
    	sku_name: '<SKU Name>',
    	sku_tier: '<SKU Tier>',
    	sku_family: '<SKU Family>',
    	service_provider_name: '<Security Provider Name>',
    	peering_location: '<Peering Location Name>',
    	bandwidth_in_mbps: <Bandwidth Value>,
    	peerings: [
        	{
            	name: '<Peering Name>',
            	peering_type: '<Peering Type>',
            	peer_asn: <ASN Value>,
            	primary_peer_address_prefix: '<Primary Peer IP Address Range>',
            	secondary_peer_address_prefix: '<Secondary Peer IP Address Range>',
            	vlan_id: <VLAN Id>
        	}
    	],
        tags: {                                     # [Optional]
    	        	key1: 'value1',
    		        key2: 'value2'
  	}
)
```

## List Express Route Circuits

List all express route circuits in a resource group

```ruby
circuits  = network.express_route_circuits(resource_group: '<Resource Group Name>')
circuits.each do |circuit|
    	puts "#{circuit.name}"
end
```

## Retrieve a single Express Route Circuit

Get a single record of Express Route Circuit

```ruby
circuit = network.express_route_circuits.get('<Resource Group Name>', '<Circuit Name>')
puts "#{circuit.name}"
```

## Destroy a single Express Route Circuit

Get an express route circuit object from the get method and then destroy that express route circuit.

```ruby
circuit.destroy
```
# Express Route Authorization

Authorization is part of Express Route circuit.

## Check Express Route Circuit Authorization Existence

```ruby
fog_network_service.express_route_circuit_authorizations.check_express_route_cir_auth_exists('<Resource Group Name>', '<Circuit Name>', '<Authorization Name>')
```

## Create an Express Route Circuit Authorization

Create a new Express Route Circuit Authorization. Parameter 'authorization_status' can be 'Available' or 'InUse'.

```ruby
authorization = network.express_route_circuit_authorizations.create(
    	resource_group: '<Resourse Group Name>',
    	name: '<Resource Unique Name>',
    	circuit_name: '<Circuit Name>',
    	authorization_status: '<Status Value>',
    	authorization_name: '<Authorization Name>'
)
```

## List Express Route Circuit Authorizations

List all express route circuit authorizations in a resource group.

```ruby
authorizations  = network.express_route_circuit_authorizations(resource_group: '<Resource Group Name>', circuit_name: '<Circuit Name>')
authorizations.each do |authorization|
    	puts "#{authorization.name}"
end
```

## Retrieve single Express Route Circuit Authorization

Get a single record of Express Route Circuit Authorization.

```ruby
authorization = network.express_route_circuit_authorizations.get('<Resource Group Name>', '<Circuit Name>', '<Authorization Name>')
puts "#{authorization.name}"
```

## Destroy single Express Route Circuit Authorization

Get an express route circuit authorization object from the get method and then destroy that express route circuit authorization.

```ruby
authorization.destroy
```


# Express Route Peering

BGP Peering is part of Express Route circuit and defines the type of connectivity needed with Microsoft.

## Create an Express Route Circuit Peering

Create a new Express Route Circuit Peering.

```ruby
peering = network.express_route_circuit_peerings.create(
    	name: '<Peering Name>',
    	circuit_name: '<Circuit Name>',
    	resource_group: '<Resourse Group Name>',
    	peering_type: '<Peering Type>',
    	peer_asn: <ASN Value>,
    	primary_peer_address_prefix: '<Primary Peer IP Address Range>',
    	secondary_peer_address_prefix:'<Secondary Peer IP Address Range>',
    	vlan_id: <VLAN Id>
)
```

## List Express Route Circuit Peerings

List all express route circuit peerings in a resource group

```ruby
peerings  = network.express_route_circuit_peerings(resource_group: '<Resource Group Name>', circuit_name: '<Circuit Name>')
peerings.each do |peering|
    	puts "#{peering.name}"
end
```

## Retrieve single Express Route Circuit Peering

Get a single record of Express Route Circuit Peering

```ruby
peering = network.express_route_circuit_peerings.get('<Resource Group Name>', '<Peering Name>', '<Circuit Name>')
puts "#{peering.peering_type}"
```

## Destroy single Express Route Circuit Peering

Get an express route circuit peering object from the get method and then destroy that express route circuit peering.

```ruby
peering.destroy
```

# Express Route Service Provider

Express Route Service Providers are telcos and exchange providers who are approved in the system to provide Express Route connectivity.

## List Express Route Service Providers

List all express route service providers

```ruby
service_providers = network.express_route_service_providers
puts service_providers
```

## Check Virtual Network Gateway Connection Existence

```ruby
fog_network_service.virtual_network_gateway_connections.check_vnet_gateway_connection_exists('<Resource Group Name>', '<Virtual Network Gateway Connection Name>')
```

## Create Virtual Network Gateway Connection

Create a new Virtual Network Gateway Connection.

```ruby
gateway_connection = network.virtual_network_gateway_connections.create(
      name: '<Virtual Network Gateway Connection Name>',
      location: '<Location>',
      resource_group: '<Resource Group Name>',
      virtual_network_gateway1: {
        name: '<VN Gateway Name>',
        resource_group: '<Resource Group Name>'
      },
      virtual_network_gateway2: {
        name: '<VN Gateway Name>',
        resource_group: '<Resource Group Name>'
      }
      connection_type: '<Connection Type>',
      tags: {                             # [Optional]
               key1: 'value1',
               key2: 'value2'
      },
)
```

## List Virtual Network Gateway Connections

List all virtual network gateway connections in a resource group

```ruby
gateway_connections = network.virtual_network_gateway_connections(resource_group: '<Resource Group Name>')
gateway_connections.each do |connection|
    	puts "#{connection.name}"
end
```

## Retrieve single Virtual Network Gateway Connection

Get single record of Virtual Network Gateway Connection

```ruby
gateway_connection = network.virtual_network_gateway_connections.get('<Resource Group Name>', '<Virtual Network Gateway Connection Name>')
puts "#{gateway_connection.name}"
```

## Destroy single Virtual Network Gateway Connection

Get a virtual network gateway connection object from the get method and then destroy that virtual network gateway connection.

```ruby
gateway_connection.destroy
```

## Get the shared key for a connection

```ruby
shared_key = network.get_connection_shared_key('<Resource Group Name>', '<Virtual Network Gateway Connection Name>')
puts gateway_connection
```

## Set the shared key for a connection

```ruby
network.set_connection_shared_key('<Resource Group Name>', '<Virtual Network Gateway Connection Name>', 'Value')
```

## Reset the shared key for a connection

```ruby
network.reset_connection_shared_key('<Resource Group Name>', '<Virtual Network Gateway Connection Name>', '<Key Length In Integer>')
```


## Support and Feedback
Your feedback is highly appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
