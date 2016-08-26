require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

resources = Fog::Resources::AzureRM.new(
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

resources.resource_groups.create(
  name: 'TestRG-ER',
  location: 'eastus'
)

########################################################################################################################
################                               Create Express Route Circuit                            #################
########################################################################################################################

network.express_route_circuits.create(
  name: 'testERCircuit',
  location: 'eastus',
  tags: {
    key1: 'value1',
    key2: 'value2'
  },
  resource_group: 'TestRG-ER',
  sku_name: 'Standard_MeteredData',
  sku_tier: 'Standard',
  sku_family: 'MeteredData',
  service_provider_name: 'Telenor',
  peering_location: 'London',
  bandwidth_in_mbps: 100,
  peerings: [
    {
      name: 'AzurePublicPeering',
      peering_type: 'AzurePublicPeering',
      peer_asn: 100,
      primary_peer_address_prefix: '192.168.1.0/30',
      secondary_peer_address_prefix: '192.168.2.0/30',
      vlan_id: 200
    }
  ]
)

########################################################################################################################
######################                           List Express Route Circuit                         ####################
########################################################################################################################

circuits = network.express_route_circuits(resource_group: 'TestRG-ER')
circuits.each do |circuit|
  puts circuit.name
end

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

circuit = network.express_route_circuits.get('TestRG-ER', 'testERCircuit')
puts circuit.name

circuit.destroy
