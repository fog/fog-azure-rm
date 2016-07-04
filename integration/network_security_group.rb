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
    :name => 'TestRG-NSG',
    :location => 'eastus'
)

########################################################################################################################
######################                          Create Network Security Group                     ######################
########################################################################################################################

nsg = network.network_security_groups.create(
    name: 'testGroup',
    resource_group: 'TestRG-NSG',
    location: 'eastus',
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
######################                    Get and Destroy Network Security Group                  ######################
########################################################################################################################

nsg = network.network_security_groups(resource_group: 'TestRG-NSG').get('testGroup')
nsg.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-NSG')
rg.destroy
