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
    name: 'TestRG-NSR',
    location: 'eastus'
)

########################################################################################################################
######################                          Create Network Security Group                     ######################
########################################################################################################################

network.network_security_groups.create(
    name: 'testGroup',
    resource_group: 'TestRG-NSR',
    location: 'eastus'
)

########################################################################################################################
######################                          Create Network Security Rule                      ######################
########################################################################################################################

network.network_security_rules.create(
  name: 'testRule',
  resource_group: 'TestRG-NSR',
  protocol: 'tcp',
  network_security_group_name: 'testGroup',
  source_port_range: '22',
  destination_port_range: '22',
  source_address_prefix: '0.0.0.0/0',
  destination_address_prefix: '0.0.0.0/0',
  access: 'Allow',
  priority: '100',
  direction: 'Inbound'
)

########################################################################################################################
######################                        List Network Security Rules                         ######################
########################################################################################################################

network_security_rules = network.network_security_rules(resource_group: 'TestRG-NSR',
                                                        network_security_group_name: 'testGroup')
network_security_rules.each do |network_security_rule|
  Fog::Logger.debug network_security_rule.name
end

########################################################################################################################
######################                          Get Network Security Rule                         ######################
########################################################################################################################

nsr = network.network_security_rules.get('TestRG-NSR', 'testGroup', 'testRule')


########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

nsr.destroy
nsg = network.network_security_groups.get('TestRG-NSR', 'testGroup')
nsg.destroy
rg = rs.resource_groups.get('TestRG-NSR')
rg.destroy
