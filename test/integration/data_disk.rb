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

begin
  resource_group = rs.resource_groups.create(
    name: 'TestRG-DD',
    location: LOCATION
  )

  storage_account = storage.storage_accounts.create(
    name: 'fogstorageac',
    location: LOCATION,
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
    key: 'vhds'
  )

  ########################################################################################################################
  ######################                               Create Disk                                  ######################
  ########################################################################################################################

  data_disk = storage_data.create_disk('datadisk1', options = {})
  puts "Created data disk: #{data_disk.name}"

  ########################################################################################################################
  ######################                                Delete Data Disk                            ######################
  ########################################################################################################################

  puts "Deleted data disk: #{storage_data.delete_disk('datadisk1')}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  container = storage_data.directories.get('vhds')
  container.destroy

  storage = storage.storage_accounts.get('TestRG-DD', 'fogstorageac')
  storage.destroy

  resource_group = rs.resource_groups.get('TestRG-DD')
  resource_group.destroy
rescue
  puts 'Integration Test for data disk is failing'
  resource_group.destroy unless resource_group.nil?
end
