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
  name: 'TestRG-SN',
  location: 'eastus'
)

network.virtual_networks.create(
  name:             'testVnet',
  location:         'eastus',
  resource_group:   'TestRG-SN',
  network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

########################################################################################################################
######################                                Create Subnet                               ######################
########################################################################################################################

network.subnets.create(
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
