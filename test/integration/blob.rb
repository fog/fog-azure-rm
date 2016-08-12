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

resource_group = rs.resource_groups.create(
  name: 'TestRG-VM',
  location: 'eastus'
)

storage_account = storage.storage_accounts.create(
  name: 'fogstorageaccounttestblob',
  location: 'eastus',
  resource_group: 'TestRG-VM'
)

access_key = storage_account.get_access_keys['key1']

storage_data = Fog::Storage.new(
  provider: 'AzureRM',
  azure_storage_account_name: storage_account.name,
  azure_storage_access_key: access_key
)

container_name = 'fogcontainertestblob'

########################################################################################################################
######################                                Create Container                            ######################
########################################################################################################################

storage_data.containers.create(
  name: container_name
)

########################################################################################################################
######################                          Get Container Properties                          ######################
########################################################################################################################

container = storage_data.containers.get(container_name)
container.get_properties

########################################################################################################################
######################                      Get container access control List                     ######################
########################################################################################################################

container.get_access_control_list

########################################################################################################################
######################                          Create a small blob                               ######################
########################################################################################################################

small_file_name = 'small_test_file.dat'
small_blob_name = small_file_name
content = Array.new(1024 * 1024) { [*'0'..'9', *'a'..'z'].sample }.join
small_file = File.new(small_file_name, 'w')
small_file.puts(content)
small_file.close

storage_data.blobs.get(container_name, small_blob_name).create(file_path: small_file_name)

File.delete(small_file_name)

########################################################################################################################
######################                          Create a large blob                               ######################
########################################################################################################################

large_file_name = 'large_test_file.dat'
large_blob_name = large_file_name
large_file = File.new(large_file_name, 'w')
33.times do
  large_file.puts(content)
end
large_file.close

storage_data.blobs.get(container_name, large_blob_name).create(file_path: large_file_name)

File.delete(large_file_name)

########################################################################################################################
######################                          Set blob properties                               ######################
########################################################################################################################

storage_data.blobs.get(container_name, large_blob_name).set_properties(content_encoding: 'utf8')

########################################################################################################################
######################                          Get blob properties                               ######################
########################################################################################################################

storage_data.blobs.get(container_name, large_blob_name).get_properties

########################################################################################################################
######################                            Downlaod blob                                   ######################
########################################################################################################################

downloaded_file_name = 'downloaded_' + small_blob_name
storage_data.blobs.get(container_name, large_blob_name).save_to_file(downloaded_file_name)
File.delete(downloaded_file_name)

########################################################################################################################
######################                            Delete Container                                ######################
########################################################################################################################

container.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

storage_account.destroy

resource_group.destroy
