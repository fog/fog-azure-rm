module Fog
  module KeyVault
    class AzureRM
      # Real class for KeyVault Request
      class Real
        def list_vaults(resource_group)
          msg = "Listing Vaults in Resource Group: #{resource_group}."
          Fog::Logger.debug msg
          begin
            vaults = @key_vault_client.vaults.list_by_resource_group(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Vaults listed successfully in Resource Group: #{resource_group}"
          vaults.value
        end
      end

      # Mock class for KeyVault Request
      class Mock
        def list_vaults(*)
          vaults = [
              {
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
          ]
          vaults_mapper = Azure::ARM::KeyVault::Models::VaultListResult.mapper
          @kay_vault_client.deserialize(vaults_mapper, vaults, 'result.body')
        end
      end
    end
  end
end
