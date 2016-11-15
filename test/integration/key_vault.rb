require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

resources = Fog::Resources::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

key_vault = Fog::KeyVault::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

resources.resource_groups.create(
  name: 'TestRG-KV',
  location: 'eastus'
)

########################################################################################################################
######################                         Create Vault                                       ######################
########################################################################################################################

access_policies_arr = [
  {
    tenant_id: azure_credentials['tenant_id'],
    object_id: azure_credentials['tenant_id'],
    permissions: {
      keys: ['all'],
      secrets: ['all']
    }
  }
]

key_vault.vaults.create(
  name: 'test-tmp',
  resource_group: 'TestRG-KV',
  location: 'eastus',
  tenant_id: azure_credentials['tenant_id'],
  sku_family: 'A',
  sku_name: 'standard',
  access_policies: access_policies_arr
)

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

resource_group = resources.resource_groups.get('TestRG-KV')
resource_group.destroy
