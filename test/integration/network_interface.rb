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
  name: 'TestRG-NI',
  location: 'eastus'
)

network.virtual_networks.create(
  name:             'testVnet',
  location:         'eastus',
  resource_group:   'TestRG-NI',
  network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

network.subnets.create(
  name: 'mysubnet',
  resource_group: 'TestRG-NI',
  virtual_network_name: 'testVnet',
  address_prefix: '10.1.0.0/24'
)

network.public_ips.create(
  name: 'mypubip',
  resource_group: 'TestRG-NI',
  location: 'eastus',
  public_ip_allocation_method: 'Dynamic'
)

########################################################################################################################
######################                           Create Network Interface                         ######################
########################################################################################################################

network.network_interfaces.create(
  name: 'NetInt',
  resource_group: 'TestRG-NI',
  location: 'eastus',
  subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-NI/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
  public_ip_address_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-NI/providers/Microsoft.Network/publicIPAddresses/mypubip",
  ip_configuration_name: 'testIpConfiguration',
  private_ip_allocation_method: 'Dynamic'
)

########################################################################################################################
######################                       Get and Delete Network Interface                     ######################
########################################################################################################################

nic = network.network_interfaces.get('TestRG-NI','NetInt')
puts nic.inspect
nic.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

pubip = network.public_ips(resource_group: 'TestRG-NI').get('mypubip')
pubip.destroy

vnet = network.virtual_networks(resource_group: 'TestRG-NI').get('testVnet')
vnet.destroy

rg = rs.resource_groups.get('TestRG-NI')
rg.destroy
