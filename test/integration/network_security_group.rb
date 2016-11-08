require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

rs = Fog::Resources::AzureRM.new(
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

rs.resource_groups.create(
  name: 'TestRG-NSG',
  location: LOCATION
)

########################################################################################################################
######################                          Create Network Security Group                     ######################
########################################################################################################################

network.network_security_groups.create(
  name: 'testGroup',
  resource_group: 'TestRG-NSG',
  location: LOCATION,
  security_rules: [{
    name: 'testRule',
    protocol: 'tcp',
    source_port_range: '22',
    destination_port_range: '22',
    source_address_prefix: '0.0.0.0/0',
    destination_address_prefix: '0.0.0.0/0',
    access: 'Allow',
    priority: '100',
    direction: 'Inbound'
  }]
)

########################################################################################################################
######################                    Get and Update Network Security Group                  ######################
########################################################################################################################

nsg = network.network_security_groups.get('TestRG-NSG', 'testGroup')
nsg.update_security_rules(
  security_rules:
    [
      {
        name: 'testRule',
        protocol: 'tcp',
        source_port_range: '*',
        destination_port_range: '22',
        source_address_prefix: '0.0.0.0/0',
        destination_address_prefix: '0.0.0.0/0',
        access: 'Allow',
        priority: '100',
        direction: 'Inbound'
      }
    ]
)

########################################################################################################################
######################                        List Network Security Group                         ######################
########################################################################################################################

network_security_groups = network.network_security_groups(resource_group: 'TestRG-NSG')
network_security_groups.each do |network_security_group|
  Fog::Logger.debug network_security_group.name
end

########################################################################################################################
######################                    Add and Remove Network Security Rules                  ######################
########################################################################################################################

nsg.add_security_rules(
  [
    {
      name: 'testRule2',
      protocol: 'tcp',
      source_port_range: '22',
      destination_port_range: '22',
      source_address_prefix: '0.0.0.0/0',
      destination_address_prefix: '0.0.0.0/0',
      access: 'Allow',
      priority: '102',
      direction: 'Inbound'
    }
  ]
)
nsg.remove_security_rule('testRule')

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

nsg.destroy
rg = rs.resource_groups.get('TestRG-NSG')
rg.destroy
