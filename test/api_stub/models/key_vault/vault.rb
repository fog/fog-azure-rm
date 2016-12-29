module ApiStub
  module Models
    module KeyVault
      # Mock class for Vault Model
      class Vault
        def self.create_vault_response(key_vault_client)
          vault = {
            'id' => '/subscriptions/<AZURE_SUBSCRIPTION_ID>/resourceGroups/fog-test-rg/providers/Microsoft.KeyVault/vaults/fog-test-kv',
            'name' => 'fog-test-kv',
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
              'vaultUri' => 'https://fog-test-kv.vault.azure.net/'
            }
          }
          vault_mapper = Azure::ARM::KeyVault::Models::Vault.mapper
          key_vault_client.deserialize(vault_mapper, vault, 'result.body')
        end
      end
    end
  end
end
