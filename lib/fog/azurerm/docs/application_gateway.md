# Application Gateway

This document explains how to get started using Azure Network Service with Fog to manage Application Gateway. With this gem you can create/update/list/delete Application Gateway.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```
## Create Connection

Next, create a connection to the Application Gateway Service:

```ruby
azure_application_gateway_service = Fog::ApplicationGateway::AzureRM.new(
      tenant_id:        '<TenantId>',                                                     # Tenant id of Azure Active Directory Application
      client_id:        '<ClientId>',                                                     # Client id of Azure Active Directory Application
      client_secret:    '<ClientSecret>',                                                 # Client Secret of Azure Active Directory Application
      subscription_id:  '<SubscriptionId>',                                               # Subscription id of an Azure Account
      environment:      '<AzureCloud/AzureChinaCloud/AzureUSGovernment/AzureGermanCloud>' # Azure cloud environment. Default is AzureCloud.
)
```

## Check Application Gateway Existence

```ruby
azure_application_gateway_service.gateways.check_application_gateway_exists(<Resource Group Name>, <Gateway Name>)
```

## Create Application Gateway

Create a new Application Gateway.

```ruby
gateway = azure_application_gateway_service.gateways.create(
        name: '<Gateway Name>',
        location: '<Location>',
        resource_group: '<Resource Group name>',
        sku_name: '<SKU Name>',
        sku_tier: '<SKU Tier Type>',
        sku_capacity: '<SKU Capacity>',
        gateway_ip_configurations:
            [
                {
                    name: '<Gateway IP Config Name>',
                    subnet_id: '/subscriptions/<Subscription_id>/resourcegroups/<Resource Group Name>/providers/Microsoft.Network/virtualNetworks/<Virtual Network Name>/subnets/<Subnet Name>'
                }
            ],
        frontend_ip_configurations:
            [
                {
                    name: '<Frontend IP Config Name>',
                    private_ip_allocation_method: '<Static/ Dynamic>',
                    public_ip_address_id: '/subscriptions/<Subscription_id>/resourcegroups/<Resource Group Name>/providers/Microsoft.Network/publicIPAddresses/<Public IP Address Name>',
                    private_ip_address: '<IP Address>'
                }
            ],
        frontend_ports:
            [
                {
                    name: '<Frontend Port Name>',
                    port: <Port Number>
                }
            ],
        backend_address_pools:
            [
                {
                    name: '<Backend Address Pool Name>',
                    ip_addresses: [
                        {
                            ipAddress: '<IP Address>'
                        }
                    ]
                }
            ],
        backend_http_settings_list:
            [
                {
                    name: '<Gateway Settings Name>',
                    port: <Port Number>,
                    protocol: '<Protocol Name>',
                    cookie_based_affinity: 'Enabled',
                    request_timeout: '<Timeout Time>'
                }
            ],
        http_listeners:
            [
                {
                    name: '<Gateway Listener Name>',
                    frontend_ip_config_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/frontendIPConfigurations/<Frontend IP Config Name>',
                    frontend_port_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/frontendPorts/<Frontend Port Name>',
                    protocol: '<Protocol Name>',
                    host_name: '',
                    require_server_name_indication: '<True/ False>'
                }
            ],
        request_routing_rules:
            [
                {
                    name: '<Gateway Request Route Rule Name>',
                    type: '<Type>',
                    http_listener_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/httpListeners/<Gateway Listener Name>',
                    backend_address_pool_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/backendAddressPools/<Backend Address Pool Name>',
                    backend_http_settings_id: '/subscriptions/<Subscription_id>/resourceGroups/<Resource Group Name>/providers/Microsoft.Network/applicationGateways/<Gateway Name>/backendHttpSettingsCollection/<Gateway Settings Name>',
                    url_path_map: ''
                }
            ],
	 tags: { key1: "value1", key2: "value2", keyN: "valueN" }                          # [Optional]
)
```

There can be two ways of giving `frontend_ip_configurations` while creating application gateway

1. When giving public IP, then we need to provide `public_ip_address_id` as follows

```ruby
	frontend_ip_configurations:
	[
		{
			name: '<Frontend IP Config Name>',
			private_ip_allocation_method: '<Static/ Dynamic>',
			public_ip_address_id: '/subscriptions/<Subscription_id>/resourcegroups/<Resource Group Name>/providers/Microsoft.Network/publicIPAddresses/<Public IP Address Name>',
			private_ip_address: '<IP Address>'
		}
	]
```

2. When giving subnet id, then we need to provide `subnet_id` as follows

	```ruby
	frontend_ip_configurations:
	[
		{
			name: '<Frontend IP Config Name>',
			private_ip_allocation_method: '<Static/ Dynamic>',
			subnet_id: '<Subnet ID>',
			private_ip_address: '<IP Address>'
		}
	]
```

## List Application Gateways

List all application gateways in a resource group

```ruby
gateways = azure_application_gateway_service.gateways(resource_group: '<Resource Group Name>')
gateways.each do |gateway|
	puts "#{gateway.name}"
end
```

## Retrieve a single Application Gateway

Get a single record of Application Gateway

```ruby
gateway = azure_application_gateway_service
                            .gateways
                            .get('<Resource Group name>', '<Application Gateway Name>')
puts "#{gateway.name}"
```


## Update SKU attributes (Name and Capacity)                

```ruby
ag.update_sku('<SKU Name>', '<SKU Capacity>')
```

## Update gateway IP configuration (Subnet id) 

```ruby
ag.update_gateway_ip_configuration("/subscriptions/<Subscription_id>/<Resource Group Name>/<Gateway Name>/providers/Microsoft.Network/virtualNetworks/<Virtual Network Name>/subnets/<Subnet Name>")
```

## Add/ Remove SSL Certificates 

```ruby
ag.add_ssl_certificate(
	{
       name: '<SSL Certificate Name>',
       data: '<SSL Certificate Data>',
       password: '<Password>',
       public_cert_data: '<Public Certificate Data>'
	}
)
    
ag.remove_ssl_certificate(
	{
       name: '<SSL Certificate Name>',
       data: '<SSL Certificate Data>',
       password: '<Password>',
       public_cert_data: '<Public Certificate Data>'
	}
)
```

## Add/ Remove Frontend ports    

```ruby
ag.add_frontend_port({name: '<Frontend Port Name>', port: <Port Number>})
    
ag.remove_frontend_port({name: '<Frontend Port Name>', port: <Port Number>})
```

## Add/ Remove Probes    

```ruby
ag.add_probe(
  {
    name: '<Probe Name>',
    protocol: '<Protocol Name>',
    host: '<Host Name>',
    path: '<Probe Path>',
    interval: <Interval Time>, 
    timeout: <Timeout Time>,
    unhealthy_threshold: <Threshold Number>
  }
)

ag.remove__probe(
  {
    name: '<Probe name>',
    protocol: '<Protocol Name>',
    host: '<Protocol Name>',
    path: '<Probe Path>',
    interval: <Interval Time>, 
    timeout: <Timeout Time>,
    unhealthy_threshold: <Threshold Number>
  }
)
```

## Destroy a single Application Gateway

Get a application gateway object from the get method and then destroy that application gateway.

```ruby
gateway.destroy
```

## Support and Feedback
Your feedback is highly appreciated! If you have specific issues with the Fog ARM, you should file an issue via Github.
