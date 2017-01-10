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

begin
  resources.resource_groups.create(
    name: 'TestRG-KV',
    location: 'eastus'
  )

  ########################################################################################################################
  ######################                      Check Key Vault Exists?                               ######################
  ########################################################################################################################

  if !key_vault.vaults.check_vault_exists('TestRG-KV', 'test-tmp')
    puts "Key vault doesn't exist."
  end

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
  ######################                            List Vault                                      ######################
  ########################################################################################################################

  vaults = key_vault.vaults(resource_group: 'TestRG-KV')
  vaults.each do |vault|
    puts vault.name.to_s
  end

  ########################################################################################################################
  ######################                      Get Single Vault                                      ######################
  ########################################################################################################################

  vault = key_vault.vaults.get('TestRG-KV', 'test-tmp')

  ########################################################################################################################
  ######################                            Destroy Vault                                   ######################
  ########################################################################################################################

  vault.destroy

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  resource_group = resources.resource_groups.get('TestRG-KV')
  resource_group.destroy
  puts 'Integration Test for key vault ran successfully'
rescue
  puts 'Integration Test for key vault is failing'
  resource_group.destroy unless resource_group.nil?
end
