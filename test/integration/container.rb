require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

resource = Fog::Resources::AzureRM.new(
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
  resource_group = resource.resource_groups.create(
    name: 'TestRG-Con',
    location: LOCATION
  )

  storage_account_name = "fog#{get_time}storageac"

  storage_account = storage.storage_accounts.create(
    name: storage_account_name,
    location: LOCATION,
    resource_group: 'TestRG-Con'
  )

  keys = storage_account.get_access_keys
  access_key = keys.first.value

  storage_data = Fog::Storage.new(
    provider: 'AzureRM',
    azure_storage_account_name: storage_account.name,
    azure_storage_access_key: access_key
  )

  ########################################################################################################################
  ######################                                Create Container                            ######################
  ########################################################################################################################

  container = storage_data.directories.create(
    key: 'fogcontainer'
  )
  puts "Created container: #{container.key}"

  storage_data.directories.create(
    key: 'fogcontainer2',
    public: true
  )
  puts "Created second container: #{container.key}"

  ########################################################################################################################
  ######################                      List containers                                       ######################
  ########################################################################################################################

  containers = storage_data.directories.all
  puts 'List containers:'
  containers.each do |a_container|
    puts a_container.name
  end

  ########################################################################################################################
  ######################                      Get container acl                                     ######################
  ########################################################################################################################

  container = storage_data.directories.get('fogcontainer', max_results: 1)
  puts "Get container: #{container.key}"
  puts "Get container access control list: #{container.acl}"

  ########################################################################################################################
  ######################                          Update Container                                  ######################
  ########################################################################################################################

  container.acl = 'container'
  container.metadata = { 'owner' => 'azure' }
  container.save(is_create: false)
  puts 'Updated container'

  ########################################################################################################################
  ######################                      Get container acl                                     ######################
  ########################################################################################################################

  puts "Get updated container access control list: #{container.acl}"

  ########################################################################################################################
  ######################                      Get container metadata                                ######################
  ########################################################################################################################

  puts "Get container metadata: #{container.metadata}"

  ########################################################################################################################
  ######################                      Get container public https url                        ######################
  ########################################################################################################################

  puts "Get container public url: #{container.public_url}"

  ########################################################################################################################
  ######################                      Get container public http url                         ######################
  ########################################################################################################################

  puts "Get container public url having scheme http: #{container.public_url(scheme: 'http')}"

  ########################################################################################################################
  ######################                                Deleted Container                           ######################
  ########################################################################################################################

  puts "Deleted container: #{container.destroy}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  storage_account.destroy

  resource_group.destroy
rescue
  puts 'Integration Test for container is failing'
  resource_group.destroy unless resource_group.nil?
end
