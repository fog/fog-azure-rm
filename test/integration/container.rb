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
    name: 'TestRG-Con',
    location: 'eastus'
)

storage_account_name = "fog#{get_time}storageac"

storage_account = storage.storage_accounts.create(
    name: storage_account_name,
    location: 'eastus',
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

storage_data.directories.create(
    key: 'fogcontainer'
)

########################################################################################################################
######################                          Get Container Properties                          ######################
########################################################################################################################

container = storage_data.directories.get('fogcontainer')
container.get_properties

########################################################################################################################
######################                      Get container access control List                     ######################
########################################################################################################################

container.access_control_list

########################################################################################################################
######################                            Delete Container                                ######################
########################################################################################################################

container.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

storage_account.destroy

resource_group.destroy
