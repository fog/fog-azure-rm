module ApiStub
  module Requests
    module KeyVault
      # Mock class for Vault Requests
      class Vault
        def self.create_vault_response(key_vault_client)
          response = '{
            "id" : "/subscriptions/{AZURE_SUBSCRIPTION_ID}/resourceGroups/fog-test-rg/providers/Microsoft.KeyVault/vaults/fog-test-kv",
            "name" : "fog-test-kv",
            "type" : "Microsoft.KeyVault/vaults",
            "location" : "westus",
            "tags" : {},
            "properties" : {
              "sku" : {
                "family" : "A",
                "name" : "standard"
              },
              "tenantId" : "{AZURE_TENANT_ID}",
              "accessPolicies" : [
                {
                   "tenantId" : "{AZURE_TENANT_ID}",
                   "objectId" : "{AZURE_OBJECT_ID}",
                   "permissions" : {
                     "keys" : ["all"],
                     "secrets" : ["all"]
                   }
                }
              ],
              "enabledForDeployment" : false,
              "vaultUri" : "https://fog-test-kv.vault.azure.net/"
            }
          }'
          vault_mapper = Azure::ARM::KeyVault::Models::Vault.mapper
          key_vault_client.deserialize(vault_mapper, Fog::JSON.decode(response), 'result.body')
        end

        def self.vault_params
          access_policies_arr = [
            {
              tenant_id: '{AZURE_TENANT_ID}',
              object_id: '{AZURE_TENANT_ID}',
              permissions: {
                keys: ['all'],
                secrets: ['all']
              }
            }
          ]

          {
            name: 'test-tmp',
            resource_group: 'TestRG-KV',
            location: 'eastus',
            tenant_id: '{AZURE_TENANT_ID}',
            sku_family: 'A',
            sku_name: 'standard',
            access_policies: access_policies_arr
          }
        end

        def self.list_vault_response(key_vault_client)
          response = '{
            "value": [{
              "id" : "/subscriptions/{AZURE_SUBSCRIPTION_ID}/resourceGroups/fog-test-rg/providers/Microsoft.KeyVault/vaults/fog-test-kv",
              "name" : "fog-test-kv",
              "type" : "Microsoft.KeyVault/vaults",
              "location" : "westus",
              "tags" : {},
              "properties" : {
                "sku" : {
                  "family" : "A",
                  "name" : "standard"
                },
                "tenantId" : "{AZURE_TENANT_ID}",
                "accessPolicies" : [
                  {
                     "tenantId" : "{AZURE_TENANT_ID}",
                     "objectId" : "{AZURE_OBJECT_ID}",
                     "permissions" : {
                       "keys" : ["all"],
                       "secrets" : ["all"]
                     }
                  }
                ],
                "enabledForDeployment" : false,
                "vaultUri" : "https://fog-test-kv.vault.azure.net/"
              }
            }]
          }'
          vaults_mapper = Azure::ARM::KeyVault::Models::VaultListResult.mapper
          key_vault_client.deserialize(vaults_mapper, Fog::JSON.decode(response), 'result.body')
        end
      end
    end
  end
end
