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
  name: 'TestRG-VN',
  location: 'eastus'
)

########################################################################################################################
######################                   Check Virtual Network name Availability                  ######################
########################################################################################################################

network.virtual_networks.check_if_exists('testVnet', 'TestRG-VN')

########################################################################################################################
######################            Create Virtual Network with complete parameters list            ######################
########################################################################################################################

network.virtual_networks.create(
  name:             'testVnet',
  location:         'eastus',
  resource_group:   'TestRG-VN',
  subnets:          [{
    name: 'mysubnet',
    address_prefix: '10.1.0.0/24'
  }],
  dns_servers:       ['10.1.0.0', '10.2.0.0'],
  address_prefixes:  ['10.1.0.0/16', '10.2.0.0/16']
)

########################################################################################################################
######################                      Get and Destroy Virtual Network                       ######################
########################################################################################################################

vnet = network.virtual_networks(resource_group: 'TestRG-VN').get('testVnet')
vnet.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-VN')
rg.destroy
