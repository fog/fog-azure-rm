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
  name: 'TestRG-LNG',
  location: 'eastus'
)

########################################################################################################################
######################                           Create Local Network Gateway                   ######################
########################################################################################################################

network.local_network_gateways.create(
  name: 'testlocalnetworkgateway',
  location: 'eastus',
  tags: {
    key1: 'value1',
    key2: 'value2'
  },
  resource_group: 'TestRG-LNG',
  gateway_ip_address: '192.168.1.1',
  local_network_address_space_prefixes: [],
  asn: 100,
  bgp_peering_address: '192.168.1.2',
  peer_weight: 3
)

########################################################################################################################
######################                      List Local Network Gateways                           ######################
########################################################################################################################

local_network_gateways = network.local_network_gateways(resource_group: 'TestRG-LNG')
local_network_gateways.each do |gateway|
  puts gateway.name.to_s
end

########################################################################################################################
######################                        Get Local Network Gateway                           ######################
########################################################################################################################

local_network_gateway = network.local_network_gateways.get('TestRG-LNG', 'testlocalnetworkgateway')
puts local_network_gateway.name.to_s

########################################################################################################################
######################                              CleanUp                                       ######################
########################################################################################################################

local_network_gateway.destroy

resource_group = resource.resource_groups.get('TestRG-LNG')
resource_group.destroy
