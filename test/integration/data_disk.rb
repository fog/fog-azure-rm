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
  name: 'TestRG-DD',
  location: 'eastus'
)

storage_account = storage.storage_accounts.create(
  name: 'fogstorageac',
  location: 'eastus',
  resource_group: 'TestRG-DD',
  account_type: 'Standard',
  replication: 'LRS'
)

access_key = storage_account.get_access_keys[0].value
Fog::Logger.debug access_key.inspect
storage_data = Fog::Storage.new(
  provider: 'AzureRM',
  azure_storage_account_name: storage_account.name,
  azure_storage_access_key: access_key
)
storage_data.directories.create(
  name: 'vhds',
  key: access_key
)

########################################################################################################################
######################                               Create Disk                                  ######################
########################################################################################################################

storage_data.create_disk('datadisk1', options = {})

########################################################################################################################
######################                                Delete Data Disk                            ######################
########################################################################################################################

storage_data.delete_disk('datadisk1')

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

container = storage_data.directories.get('vhds')
container.destroy

storage = storage.storage_accounts.get('TestRG-VM', 'fogstorageac')
storage.destroy

resource_group = rs.resource_groups.get('TestRG-VM')
resource_group.destroy
