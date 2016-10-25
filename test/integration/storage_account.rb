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
  resource_group: 'TestRG-SA'
)

########################################################################################################################
###############      Create A Standard Storage Account of Replication: GRS (Geo-redundant storage)     #################
########################################################################################################################

storage.storage_accounts.create(
  name: 'fogstandardsagrs',
  location: 'eastus',
  resource_group: 'TestRG-SA',
  sku_name: 'Standard',
  replication: 'GRS',
  encryption: true
)

########################################################################################################################
###########   Create A Premium(SSD) Storage Account of its only Replication: LRS (Locally-redundant storage)  ##########
########################################################################################################################

storage.storage_accounts.create(
  name: 'fogpremiumsa',
  location: 'eastus',
  resource_group: 'TestRG-SA',
  sku_name: 'Premium',
  replication: 'LRS'
)

########################################################################################################################
######################                         Get and Update Storage Account                     ######################
########################################################################################################################

premium_storage_account = storage.storage_accounts.get('TestRG-SA', 'fogpremiumsa')
premium_storage_account.update(encryption: true)

########################################################################################################################
######################                         Get and Delete Storage Account                     ######################
########################################################################################################################

standard_storage_account = storage.storage_accounts.get('TestRG-SA', 'fogstandardsalrs')
standard_storage_account.destroy
standard_storage_account = storage.storage_accounts.get('TestRG-SA', 'fogstandardsagrs')
standard_storage_account.destroy
premium_storage_account = storage.storage_accounts.get('TestRG-SA', 'fogpremiumsa')
premium_storage_account.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

resource_group = rs.resource_groups.get('TestRG-SA')
resource_group.destroy
