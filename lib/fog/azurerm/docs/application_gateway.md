# Application Gateway

This document explains how to get started using Azure Network Service with Fog to manage Application Gateway. With this gem you can create/update/list/delete Application Gateway.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```
## Create Connection

Next, create a connection to the Network Service:

```ruby
    azure_application_gateway_service = Fog::ApplicationGateway::AzureRM.new(
        tenant_id: '<Tenantid>',                  # Tenant id of Azure Active Directory Application
        client_id:    '<Clientid>',               # Client id of Azure Active Directory Application
        client_secret: '<ClientSecret>',          # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'       # Subscription id of an Azure Account
)
```

## Create Application Gateway

Create a new Application Gateway.

```ruby
    gateway = azure_application_gateway_service.gateways.create(
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
    gateways = azure_application_gateway_service.gateways(resource_group: '<Resource Group Name>')
    gateways.each do |gateway|
        puts "#{gateway.name}"
    end
```

## Retrieve a single Application Gateway

Get a single record of Application Gateway

```ruby
    gateway = azure_application_gateway_service
                            .gateways(resource_group: '<Resource Group name>')
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
