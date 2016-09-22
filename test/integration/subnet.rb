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

resource_group = rs.resource_groups.create(
  name: 'TestRG-SN',
  location: 'eastus'
)

virtual_network = network.virtual_networks.create(
  name:             'testVnet',
  location:         'eastus',
  resource_group:   'TestRG-SN',
  dns_servers:       %w(10.1.0.0 10.2.0.0),
  address_prefixes:  %w(10.1.0.0/16 10.2.0.0/16)
)

network_security_group = network.network_security_groups.create(
  name: 'testGroup',
  resource_group: resource_group.name,
  location: 'eastus'
)

########################################################################################################################
######################                                Create Subnet                               ######################
########################################################################################################################

subnet = network.subnets.create(
  name: 'mysubnet',
  resource_group: resource_group.name,
  virtual_network_name: virtual_network.name,
  address_prefix: '10.1.0.0/24'
)

########################################################################################################################
######################              Attach/Detach Network Security Group                          ######################
########################################################################################################################

subnet.attach_network_security_group(network_security_group.id)
subnet.detach_network_security_group

########################################################################################################################
##################### Attach/Detach Route Table(Pending because Route Table is not implemented yet) ###################
########################################################################################################################

########################################################################################################################
######################                             List Subnets                                   ######################
########################################################################################################################

network.subnets(resource_group: resource_group.name, virtual_network_name: virtual_network.name)

########################################################################################################################
######################                             Get Subnet                          ######################
########################################################################################################################

subnet = network.subnets.get(resource_group.name, virtual_network.name, subnet.name)

########################################################################################################################
######################                        List Free Ip Addresses in Subnet                    ######################
########################################################################################################################

Fog::Logger.debug subnet.get_available_ipaddresses_count(false)

########################################################################################################################
######################                             Delete Subnet                          ######################
########################################################################################################################

subnet.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

network_security_group.destroy

virtual_network.destroy

resource_group.destroy
