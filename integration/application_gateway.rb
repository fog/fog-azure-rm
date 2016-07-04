########################################################################################################################
######################                            Driver Code From Zeeshan                        ######################
########################################################################################################################

require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azureCredentials = YAML.load_file('credentials/azure.yml')

rs = Fog::Resources::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

network = Fog::Network::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rg = rs.resource_groups.create(
    :name => 'TestRG-AG',
    :location => 'eastus'
)

vnet = network.virtual_networks.create(
    name:             'testVnet',
    location:         'eastus',
    resource_group:   'TestRG-AG',
    network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

subnet = network.subnets.create(
    name: 'mysubnet',
    resource_group: 'TestRG-AG',
    virtual_network_name: 'testVnet',
    address_prefix: '10.1.0.0/24'
)

pubip = network.public_ips.create(
    name: 'mypubip',
    resource_group: 'TestRG-AG',
    location: 'eastus',
    public_ip_allocation_method: 'Dynamic'
)

########################################################################################################################
######################                          Create Application Gateway                        ######################
########################################################################################################################

ag = network.application_gateways.create(
    name: 'gateway',
    location: 'eastus',
    resource_group: 'TestRG-AG',
    sku_name: 'Standard_Medium',
    sku_tier: 'Standard',
    sku_capacity: '2',
    gateway_ip_configurations:
        [
            {
                name: 'gatewayIpConfigName',
                subnet_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourcegroups/TestRG-AG/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet"
            }
        ],
    frontend_ip_configurations:
        [
            {
                name: 'frontendIpConfig',
                private_ip_allocation_method: 'Dynamic',
                public_ip_address_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourcegroups/TestRG-AG/providers/Microsoft.Network/publicIPAddresses/mypubip",
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
                frontend_ip_config_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-AG/providers/Microsoft.Network/applicationGateways/gateway/frontendIPConfigurations/frontendIpConfig",
                frontend_port_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-AG/providers/Microsoft.Network/applicationGateways/gateway/frontendPorts/frontendPort",
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
                http_listener_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-AG/providers/Microsoft.Network/applicationGateways/gateway/httpListeners/gateway_listener",
                backend_address_pool_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-AG/providers/Microsoft.Network/applicationGateways/gateway/backendAddressPools/backendAddressPool",
                backend_http_settings_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-AG/providers/Microsoft.Network/applicationGateways/gateway/backendHttpSettingsCollection/gateway_settings",
                url_path_map: ''
            }
        ]
)

########################################################################################################################
######################                      Get and Destroy Application Gateway                   ######################
########################################################################################################################

ag = network.application_gateways(resource_group: 'TestRG-AG').get('gateway')
ag.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

pubip = network.public_ips(resource_group: 'TestRG-AG').get('mypubip')
pubip.destroy

vnet = network.virtual_networks(resource_group: 'TestRG-AG').get('testVnet')
vnet.destroy

rg = rs.resource_groups.get('TestRG-AG')
rg.destroy
