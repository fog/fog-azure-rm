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
    :name => 'TestRG-VN',
    :location => 'eastus'
)

########################################################################################################################
######################                   Check Virtual Network name Availability                  ######################
########################################################################################################################

network.virtual_networks.check_name_availability('testVnet','TestRG-VN')

########################################################################################################################
######################            Create Virtual Network with complete parameters list            ######################
########################################################################################################################

vnet = network.virtual_networks.create(
    name:             'testVnet',
    location:         'eastus',
    resource_group:   'TestRG-VN',
    subnet_address_list:          '10.1.0.0/24',
    dns_list:       '10.1.0.5,10.1.0.6',
    network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

########################################################################################################################
######################                      Get and Destroy Virtual Network                       ######################
########################################################################################################################

vnet = network.virtual_networks.get('testVnet', 'TestRG-VN')
vnet.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-VN')
rg.destroy
