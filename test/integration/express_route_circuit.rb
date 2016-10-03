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
puts 'Resource Group created!'
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
puts 'Express Route Circuit created!'

########################################################################################################################
######################                           List Express Route Circuit                         ####################
########################################################################################################################

circuits = network.express_route_circuits(resource_group: 'TestRG-ER')
circuits.each do |circuit|
  puts circuit.name
end

########################################################################################################################
######################                Create Express Route Circuit Authorizations                   ####################
########################################################################################################################
network.express_route_circuit_authorizations.create(
  resource_group: 'TestRG-ER',
  circuit_name: 'testERCircuit',
  authorization_use_status: 'Available',
  authorization_name: 'Test-Auth',
  name: 'Unique-Auth-Name'
)
puts 'Express Route Circuit Authorization created!'

########################################################################################################################
######################                Get a Express Route Circuit Authorization                     ####################
########################################################################################################################
authorization = network.express_route_circuit_authorizations.get('TestRG-ER', 'testERCircuit', 'Test-Auth')
puts authorization.name.to_s

########################################################################################################################
######################                List Express Route Circuit Authorizations                     ####################
########################################################################################################################
authorizations = network.express_route_circuit_authorizations(resource_group: 'TestRG-ER', circuit_name: 'testERCircuit')
authorizations.each do |auth|
  puts auth.name.to_s
end

########################################################################################################################
######################                Destroy Express Route Circuit Authorization                   ####################
########################################################################################################################
authorization = network.express_route_circuit_authorizations.get('TestRG-ER', 'testERCircuit', 'Test-Auth')
authorization.destroy
puts 'Express Route Circuit Authorization deleted!'

########################################################################################################################
######################                   Destroy Express Route Circuit                            ######################
########################################################################################################################
circuit = network.express_route_circuits.get('TestRG-ER', 'testERCircuit')
circuit.destroy
puts 'Express Route Circuit deleted!'

########################################################################################################################
######################                         CleanUp                                            ######################
########################################################################################################################
resource_group = resources.resource_groups.get('TestRG-ER')
resource_group.destroy
puts 'Resource Group deleted!'
