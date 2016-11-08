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
  name: 'TestRG-BLOB',
  location: LOCATION
)

storage_account = storage.storage_accounts.create(
  name: 'storageaccounttestblob',
  location: LOCATION,
  resource_group: 'TestRG-BLOB'
)

access_key = storage_account.get_access_keys[0].value
Fog::Logger.debug access_key.inspect
storage_data = Fog::Storage.new(
  provider: 'AzureRM',
  azure_storage_account_name: storage_account.name,
  azure_storage_access_key: access_key
)

container_name = 'fogcontainertestblob'
test_container_name = 'testcontainer'

########################################################################################################################
######################                                Create Container                            ######################
########################################################################################################################

storage_data.directories.create(
  key: container_name
)

storage_data.directories.create(
  key: test_container_name
)

########################################################################################################################
######################                          Get Container Properties                          ######################
########################################################################################################################

container = storage_data.directories.get(container_name)
container.get_properties

########################################################################################################################
######################                      Get container access control List                     ######################
########################################################################################################################

container.access_control_list

########################################################################################################################
######################                          Create a small blob                               ######################
########################################################################################################################

small_file_name = 'small_test_file.dat'
small_blob_name = small_file_name
content = Array.new(1024 * 1024) { [*'0'..'9', *'a'..'z'].sample }.join
small_file = File.new(small_file_name, 'w')
small_file.puts(content)
small_file.close

storage_data.files.get(container_name, small_blob_name).create(file_path: small_file_name)

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

storage_data.files.get(container_name, large_blob_name).create(file_path: large_file_name)

File.delete(large_file_name)

########################################################################################################################
######################                    Copy Blob                                             ########################
########################################################################################################################

Fog::Logger.debug storage_data.copy_blob(test_container_name, small_blob_name, container_name, small_blob_name)

########################################################################################################################
######################                    Copy Blob from URI                                    ########################
########################################################################################################################
blob_uri = "http://storageaccounttestblob.blob.core.windows.net/#{container_name}/#{large_file_name}"
Fog::Logger.debug storage_data.copy_blob_from_uri(test_container_name, large_file_name, blob_uri)

########################################################################################################################
######################                    Compare Blob                                             #####################
########################################################################################################################

Fog::Logger.debug storage_data.compare_container_blobs(container_name, test_container_name)

########################################################################################################################
######################                    Blob Exist                                               #####################
########################################################################################################################

blob = storage_data.check_blob_exist(container_name, small_blob_name)
if blob
  Fog::Logger.debug 'Blob exist'
end

########################################################################################################################
######################                    Blob Count in a Container                                #####################
########################################################################################################################

Fog::Logger.debug storage_data.list_blobs(container_name).length

########################################################################################################################
######################                          Set blob properties                               ######################
########################################################################################################################

storage_data.files.get(container_name, large_blob_name).set_properties(content_encoding: 'utf-8')

########################################################################################################################
######################                          Get blob properties                               ######################
########################################################################################################################

storage_data.files.get(container_name, large_blob_name).get_properties

########################################################################################################################
######################                            Downlaod blob                                   ######################
########################################################################################################################

downloaded_file_name = 'downloaded_' + small_blob_name
storage_data.files.get(container_name, large_blob_name).save_to_file(downloaded_file_name)
File.delete(downloaded_file_name)

########################################################################################################################
######################                            Lease Blob                                      ######################
########################################################################################################################

lease_id_blob = storage_data.acquire_blob_lease(container_name, large_blob_name)
Fog::Logger.debug lease_id_blob

########################################################################################################################
######################                            Release Leased Blob                             ######################
########################################################################################################################

storage_data.release_blob_lease(container_name, large_blob_name, lease_id_blob)

########################################################################################################################
######################                            Delete Blob                                     ######################
########################################################################################################################

blob_object = storage_data.files.get(container_name, large_blob_name).get_properties
blob_object.destroy

########################################################################################################################
######################                            Lease Container                                 ######################
########################################################################################################################

lease_id_container = storage_data.acquire_container_lease(container_name)
Fog::Logger.debug lease_id_container

########################################################################################################################
######################                            Release Leased Container                        ######################
########################################################################################################################

storage_data.release_container_lease(container_name, lease_id_container)

########################################################################################################################
######################                            Delete Container                                ######################
########################################################################################################################

container.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

storage_account.destroy

resource_group.destroy
