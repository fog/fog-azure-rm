module Fog
  module KeyVault
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_or_update_vault(vault_hash)
          msg = "Creating Vault: #{vault_hash[:name]}."
          Fog::Logger.debug msg
          vault_parameters = get_vault_param_object(vault_hash)
          begin
            vault = @key_vault_client.vaults.create_or_update(vault_hash[:resource_group], vault_hash[:name], vault_parameters)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Vault: #{vault_hash[:name]} created successfully."
          vault
        end

        private

        def get_vault_param_object(vault_hash)
          vault_param = Azure::ARM::KeyVault::Models::VaultCreateOrUpdateParameters.new
          vault_param.location = vault_hash[:location]
          vault_param.properties = get_vault_properties_object(vault_hash)
          vault_param
        end

        def get_vault_properties_object(vault_hash)
          vault_properties = Azure::ARM::KeyVault::Models::VaultProperties.new
          vault_properties.tenant_id = vault_hash[:tenant_id]
          vault_properties.sku = get_sku_object(vault_hash)
          vault_properties.access_policies = get_access_policies_object(vault_hash[:access_policies])
          vault_properties
        end

        def get_sku_object(vault_hash)
          sku = Azure::ARM::KeyVault::Models::Sku.new
          sku.family = vault_hash[:sku_family]
          sku.name = vault_hash[:sku_name]
          sku
        end

        def get_access_policies_object(access_policies_hash)
          access_policies_arr = []
          unless access_policies_hash.nil?
            access_policies_hash.each do |access_policy_hash|
              access_policies_arr.push(get_access_policy_entry_object(access_policy_hash))
            end
          end
          access_policies_arr
        end

        def get_access_policy_entry_object(access_policy_hash)
          access_policy_entry = Azure::ARM::KeyVault::Models::AccessPolicyEntry.new
          access_policy_entry.tenant_id = access_policy_hash[:tenant_id]
          access_policy_entry.object_id = access_policy_hash[:object_id]
          access_policy_entry.permissions = get_permission_object(access_policy_hash[:permissions])
          access_policy_entry
        end

        def get_permission_object(permission_hash)
          permission = Azure::ARM::KeyVault::Models::Permissions.new
          permission.keys = permission_hash[:keys]
          permission.secrets = permission_hash[:secrets]
          permission.certificates = permission_hash[:certificates]
          permission
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_or_update_vault(*)
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
