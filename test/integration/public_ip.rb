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
  name: 'TestRG-PB',
  location: 'eastus'
)

########################################################################################################################
######################                             Check if PublicIP exists                       ######################
########################################################################################################################

network.public_ips.check_if_exists('TestRG-PB', 'mypubip')

########################################################################################################################
######################                               Create Public IP                             ######################
########################################################################################################################

network.public_ips.create(
  name: 'mypubip',
  resource_group: 'TestRG-PB',
  location: 'eastus',
  public_ip_allocation_method: 'Static'
)

########################################################################################################################
######################                           Get and Update Public IP                         ######################
########################################################################################################################

pubip = network.public_ips.get('TestRG-PB', 'mypubip')
pubip.update(public_ip_allocation_method: 'Dynamic', idle_timeout_in_minutes: '10', domain_name_label: 'newdomainlabel')

########################################################################################################################
######################                           Get and Delete Public IP                         ######################
########################################################################################################################

pubip = network.public_ips.get('TestRG-PB', 'mypubip')
pubip.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-PB')
rg.destroy
