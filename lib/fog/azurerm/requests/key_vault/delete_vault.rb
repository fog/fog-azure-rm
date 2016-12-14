module Fog
  module KeyVault
    class AzureRM
      # Real class for KeyVault Request
      class Real
        def delete_vault(resource_group, vault_name)
          msg = "Deleting Vault: #{vault_name}."
          Fog::Logger.debug msg
          begin
            @key_vault_client.vaults.delete(resource_group, vault_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Vault: #{vault_name} deleted successfully."
          true
        end
      end

      # Mock class for KeyVault Request
      class Mock
        def delete_vault(resource_group, vault_name)
          Fog::Logger.debug "Vault #{vault_name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
