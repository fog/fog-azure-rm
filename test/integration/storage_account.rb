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
###############  Create A Standard Storage Account of Replication: LRS (Locally-redundant storage)       ###############
########################################################################################################################

storage.storage_accounts.create(
  name: 'fogstandardsalrs',
  location: 'eastus',
  resource_group: 'TestRG-SA',
  account_type: 'Standard',
  replication: 'LRS'
)

########################################################################################################################
###############      Create A Standard Storage Account of Replication: GRS (Geo-redundant storage)     #################
########################################################################################################################

storage.storage_accounts.create(
  name: 'fogstandardsagrs',
  location: 'eastus',
  resource_group: 'TestRG-SA',
  account_type: 'Standard',
  replication: 'GRS'
)

########################################################################################################################
###########   Create A Premium(SSD) Storage Account of its only Replication: LRS (Locally-redundant storage)  ##########
########################################################################################################################

storage.storage_accounts.create(
  name: 'fogpremiumsa',
  location: 'eastus',
  resource_group: 'TestRG-SA',
  account_type: 'Premium',
  replication: 'LRS'
)

########################################################################################################################
######################                         Get and Delete Storage Account                     ######################
########################################################################################################################

standard_storage_account = storage.storage_accounts(resource_group: 'TestRG-SA').get('fogstandardsalrs')
standard_storage_account.destroy
standard_storage_account = storage.storage_accounts(resource_group: 'TestRG-SA').get('fogstandardsagrs')
standard_storage_account.destroy
premium_storage_account = storage.storage_accounts(resource_group: 'TestRG-SA').get('fogpremiumsa')
premium_storage_account.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-SA')
rg.destroy
