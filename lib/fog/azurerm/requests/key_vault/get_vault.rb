module Fog
  module KeyVault
    class AzureRM
      # Real class for KeyVault Request
      class Real
        def get_vault(resource_group, vault_name)
          msg = "Getting Vault => #{vault_name} from Resource Group => #{resource_group}..."
          Fog::Logger.debug msg
          begin
            vault = @key_vault_client.vaults.get(resource_group, vault_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Vault fetched successfully from Resource Group => #{resource_group}"
          vault
        end
      end

      # Mock class for KeyVault Request
      class Mock
        def get_vault(*)
          vault = {
            'id' => '/subscriptions/<AZURE_SUBSCRIPTION_ID>/resourceGroups/RubySDKTest_azure_mgmt_kv/providers/Microsoft.KeyVault/vaults/sampleVault758347',
            'name' => 'sampleVault758347',
            'type' => 'Microsoft.KeyVault/vaults',
            'location' => 'westus',
            'tags' => {},
            'properties' => {
              'sku' => {
                'family' => 'A',
                'name' => 'standard'
              },
              'tenantId' => '<AZURE_TENANT_ID>',
              'accessPolicies' => [
                {
                  'tenantId' => '<AZURE_TENANT_ID>',
                  'objectId' => '<AZURE_OBJECT_ID>',
                  'permissions' => {
                    'keys' => ['all'],
                    'secrets' => ['all']
                  }
                }
              ],
              'enabledForDeployment' => false,
              'vaultUri' => 'https =>//samplevault758347.vault.azure.net/'
            }
          }
          vault_mapper = Azure::ARM::KeyVault::Models::Vault.mapper
          @key_vault_client.deserialize(vault_mapper, vault, 'result.body')
        end
      end
    end
  end
end
