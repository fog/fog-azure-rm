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

storage = Fog::Storage::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rs.resource_groups.create(
  name: 'TestRG-SA',
  location: 'eastus'
)

########################################################################################################################
######################                    Check Storage Account name Availability                 ######################
########################################################################################################################

storage.storage_accounts.check_name_availability('test-storage')

########################################################################################################################
######################                             Create Storage Account                         ######################
########################################################################################################################

storage = storage.storage_accounts.create(
  name: 'test-storage',
  location: 'eastus',
  resource_group: 'TestRG-SA'
)

########################################################################################################################
######################                         Get and Delete Storage Account                     ######################
########################################################################################################################

storage = storage.storage_accounts(resource_group: 'TestRG-SA').get('test-storage')
storage.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-SA')
rg.destroy
