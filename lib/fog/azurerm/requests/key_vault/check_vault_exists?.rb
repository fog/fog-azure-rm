module Fog
  module KeyVault
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_vault_exists?(resource_group, vault_name)
          msg = "Checking Vault #{vault_name}"
          Fog::Logger.debug msg
          begin
            @key_vault_client.vaults.get(resource_group, vault_name)
            Fog::Logger.debug "Vault #{vault_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Vault #{vault_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_vault_exists?(*)
          true
        end
      end
    end
  end
end
