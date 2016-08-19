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

compute = Fog::Compute::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rs.resource_groups.create(
  name: 'TestRG-AS',
  location: 'eastus'
)

########################################################################################################################
######################                             Create Availability Set                        ######################
########################################################################################################################

compute.availability_sets.create(
  name: 'test-availability-set',
  location: 'eastus',
  resource_group: 'TestRG-AS'
)

########################################################################################################################
######################                       Get and Delete Availability Set                      ######################
########################################################################################################################

avail_set = compute.availability_sets(resource_group: 'TestRG-AS').get('TestRG-AS', 'test-availability-set')
avail_set.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-AS')
rg.destroy
