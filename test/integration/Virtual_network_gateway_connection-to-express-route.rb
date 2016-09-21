require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

resource = Fog::Resources::AzureRM.new(
    tenant_id: azure_credentials['tenant_id'],
    client_id: azure_credentials['client_id'],
    client_secret: azure_credentials['client_secret'],
    subscription_id: azure_credentials['subscription_id']
)

network = Fog::Network::AzureRM.new(
    tenant_id: azure_credentials['tenant_id'],
    client_id: azure_credentials['client_id'],
    client_secret: azure_credentials['client_secret'],
    subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

resource.resource_groups.create(
    name: 'TestRG-GCE',
    location: 'eastus'
)

network.virtual_networks.create(
    name: 'testVnet',
    location: 'eastus',
    resource_group: 'TestRG-GCE',
    network_address_list: '10.1.0.0/16,10.2.0.0/16'
)

network.subnets.create(
    name: 'GatewaySubnet',
    resource_group: 'TestRG-GCE',
    virtual_network_name: 'testVnet',
    address_prefix: '10.2.0.0/24'
)

network.public_ips.create(
    name: 'mypubip',
    resource_group: 'TestRG-GCE',
    location: 'eastus',
    public_ip_allocation_method: 'Dynamic'
)

network.virtual_network_gateways.create(
    name: 'testnetworkgateway',
    location: 'eastus',
    tags: {
        key1: 'value1',
        key2: 'value2'
    },
    ip_configurations: [
        {
            name: 'default',
            private_ipallocation_method: 'Dynamic',
            public_ipaddress_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-GCE/providers/Microsoft.Network/publicIPAddresses/mypubip",
            subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-GCE/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/GatewaySubnet",
            private_ipaddress: nil
        }
    ],
    resource_group: 'TestRG-GCE',
    sku_name: 'Basic',
    sku_tier: 'Basic',
    sku_capacity: 2,
    gateway_type: 'ExpressRoute',
    enable_bgp: false,
    gateway_size: nil,
    vpn_type: 'RouteBased',
    vpn_client_address_pool: nil
)

########################################################################################################################
###############          Create Virtual Network Gateway Connection to Express Route Circuit                  ###########
########################################################################################################################

network.virtual_network_gateway_connections.create(
    name: 'testnetworkgateway-to-expressroute',
    location: 'eastus',
    resource_group: 'TestRG-GCE',
    virtual_network_gateway1: {
        name: 'testnetworkgateway',
        resource_group: 'TestRG-GCE'
    },
    # Please provide Provisioned Express Route Circuit resource id below
    peer: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroup/TestRG-GCE/providers/Microsoft.Network/expressRouteCircuits/[circuit_name]",
    connection_type: 'ExpressRoute'
)

########################################################################################################################
######################                                       CleanUp                             #######################
########################################################################################################################

gateway_connection = network.virtual_network_gateway_connections.get('TestRG-GCE', 'testnetworkgateway-to-expressroute')
gateway_connection.destroy

network_gateway = network.virtual_network_gateways.get('TestRG-GC', 'testnetworkgateway')
network_gateway.destroy

pubip = network.public_ips.get('TestRG-GC', 'mypubip')
pubip.destroy

vnet = network.virtual_networks.get('TestRG-GC', 'testVnet')
vnet.destroy

resource_group = resource.resource_groups.get('TestRG-GC')
resource_group.destroy




