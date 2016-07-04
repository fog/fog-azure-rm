########################################################################################################################
######################                            Driver Code From Adnaan                        ######################
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
    :name => 'TestRG-SN',
    :location => 'eastus'
)

vnet = network.virtual_networks.create(
    name:             'testVnet',
    location:         'eastus',
    resource_group:   'TestRG-SN',
    network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

########################################################################################################################
######################                                Create Subnet                               ######################
########################################################################################################################

subnet = network.subnets.create(
    name: 'mysubnet',
    resource_group: 'TestRG-SN',
    virtual_network_name: 'testVnet',
    address_prefix: '10.1.0.0/24'
)

########################################################################################################################
######################                             Get and Delete Subnet                          ######################
########################################################################################################################

subnet = network.subnets(resource_group: 'TestRG-SN', virtual_network_name: 'testVnet').get('mysubnet')
subnet.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

vnet = network.virtual_networks(resource_group: 'TestRG-SN').get('testVnet')
vnet.destroy

rg = rs.resource_groups.get('TestRG-SN')
rg.destroy
