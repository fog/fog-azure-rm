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
  name: 'TestRG-GC',
  location: 'eastus'
)

network.virtual_networks.create(
  name: 'testVnet',
  location: 'eastus',
  resource_group: 'TestRG-GC',
  network_address_list: '10.1.0.0/16,10.2.0.0/16'
)

network.virtual_networks.create(
  name: 'testVnet2',
  location: 'eastus',
  resource_group: 'TestRG-GC',
  network_address_list: '10.3.0.0/16,10.4.0.0/16'
)

network.subnets.create(
  name: 'GatewaySubnet',
  resource_group: 'TestRG-GC',
  virtual_network_name: 'testVnet',
  address_prefix: '10.2.0.0/24'
)

network.subnets.create(
  name: 'GatewaySubnet',
  resource_group: 'TestRG-GC',
  virtual_network_name: 'testVnet2',
  address_prefix: '10.2.0.0/24'
)

network.public_ips.create(
  name: 'mypubip',
  resource_group: 'TestRG-GC',
  location: 'eastus',
  public_ip_allocation_method: 'Dynamic'
)

network.public_ips.create(
  name: 'mypubip2',
  resource_group: 'TestRG-GC',
  location: 'eastus',
  public_ip_allocation_method: 'Dynamic'
)

network.local_network_gateways.create(
  name: 'testlocalnetworkgateway',
  location: 'eastus',
  tags: {
    key1: 'value1',
    key2: 'value2'
  },
  resource_group: 'TestRG-GC',
  gateway_ip_address: '192.168.1.1',
  local_network_address_space_prefixes: [],
  asn: 100,
  bgp_peering_address: '192.168.1.2',
  peer_weight: 3
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
      public_ipaddress_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-GC/providers/Microsoft.Network/publicIPAddresses/mypubip",
      subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-GC/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/GatewaySubnet",
      private_ipaddress: nil
    }
  ],
  resource_group: 'TestRG-GC',
  sku_name: 'Standard',
  sku_tier: 'Standard',
  sku_capacity: 2,
  gateway_type: 'vpn',
  enable_bgp: true,
  gateway_size: nil,
  asn: 100,
  bgp_peering_address: nil,
  peer_weight: 3,
  vpn_type: 'RouteBased',
  vpn_client_address_pool: [],
  gateway_default_site: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-GC/providers/Microsoft.Network/localNetworkGateways/testlocalnetworkgateway"
)

network.virtual_network_gateways.create(
  name: 'testnetworkgateway2',
  location: 'eastus',
  tags: {
    key1: 'value1',
    key2: 'value2'
  },
  ip_configurations: [
    {
      name: 'default',
      private_ipallocation_method: 'Dynamic',
      public_ipaddress_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-GC/providers/Microsoft.Network/publicIPAddresses/mypubip2",
      subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-GC/providers/Microsoft.Network/virtualNetworks/testVnet2/subnets/GatewaySubnet",
      private_ipaddress: nil
    }
  ],
  resource_group: 'TestRG-GC',
  sku_name: 'Standard',
  sku_tier: 'Standard',
  sku_capacity: 2,
  gateway_type: 'vpn',
  enable_bgp: true,
  gateway_size: nil,
  asn: 100,
  bgp_peering_address: nil,
  peer_weight: 3,
  vpn_type: 'RouteBased',
  vpn_client_address_pool: [],
  gateway_default_site: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-GC/providers/Microsoft.Network/localNetworkGateways/testlocalnetworkgateway"
)

########################################################################################################################
######################                           Create Virtual Network Gateway Connection                   ###########
########################################################################################################################

network.virtual_network_gateway_connections.create(
  name: 'testnetworkgateway2-to-testnetworkgateway',
  location: 'eastus',
  resource_group: 'TestRG-GC',
  virtual_network_gateway1: {
    name: 'testnetworkgateway2',
    resource_group: 'TestRG-GC'
  },
  virtual_network_gateway2: {
    name: 'testnetworkgateway',
    resource_group: 'TestRG-GC'
  },
  connection_type: 'Vnet2Vnet'
)

########################################################################################################################
######################                      List Virtual Network Gateway Connections                         ###########
########################################################################################################################

gateway_connections = network.virtual_network_gateway_connections(resource_group: 'TestRG-GC')
gateway_connections.each do |connection|
  puts connection.name
end

########################################################################################################################
######################                  Get Virtual Network Gateway Connection and CleanUp                   ###########
########################################################################################################################

gateway_connection = network.virtual_network_gateway_connections.get('TestRG-GC', 'testnetworkgateway2-to-testnetworkgateway')
puts gateway_connection.name

gateway_connection.destroy

network_gateway = network.virtual_network_gateways.get('TestRG-GC', 'testnetworkgateway')
network_gateway.destroy

network_gateway = network.virtual_network_gateways.get('TestRG-GC', 'testnetworkgateway2')
network_gateway.destroy

local_network_gateway = network.local_network_gateways.get('TestRG-GC', 'testlocalnetworkgateway')
local_network_gateway.destroy

pubip = network.public_ips.get('TestRG-GC', 'mypubip')
pubip.destroy

pubip = network.public_ips.get('TestRG-GC', 'mypubip2')
pubip.destroy

vnet = network.virtual_networks.get('TestRG-GC', 'testVnet')
vnet.destroy

vnet = network.virtual_networks.get('TestRG-GC', 'testVnet2')
vnet.destroy

resource_group = resource.resource_groups.get('TestRG-GC')
resource_group.destroy
