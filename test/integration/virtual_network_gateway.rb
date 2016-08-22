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
  name: 'TestRG-VNG',
  location: 'eastus'
)

########################################################################################################################
######################                           Create Virtual Network Gateway                   ######################
########################################################################################################################

network.virtual_network_gateways.create(
  name: 'testNetworkGateway',
  location: 'eastus',
  tags: {
      key1: 'value1',
      key2: 'value2'
  },
  resource_group: 'TestRG-VNG',
  sku_name: 'HighPerformance',
  sku_tier: 'Standard',
  sku_capacity: 100,
  gateway_type: 'ExpressRoute',
  enable_bgp: true,
  gateway_size: 'Default',
  vpn_client_address_pool: [ 'vpnClientAddressPoolPrefix' ],
  default_sites: [ 'mysite1' ]
)

########################################################################################################################
######################                      List Virtual Network Gateways                         ######################
########################################################################################################################

network_gateways  = network.virtual_network_gateways(resource_group: 'TestRG-VNG')
network_gateways.each do |gateway|
  puts "#{gateway.name}"
end

########################################################################################################################
######################                  Get Virtual Network Gateway and CleanUp                   ######################
########################################################################################################################

network_gateway = network.virtual_network_gateways.get('learn_fog', 'testVNG')
puts "#{network_gateway.name}"

network_gateway.destroy
