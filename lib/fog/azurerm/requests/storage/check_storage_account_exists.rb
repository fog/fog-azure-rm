module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_storage_account_exists(resource_group_name, storage_account_name)
          msg = "Checking Storage Account: #{storage_account_name}."
          Fog::Logger.debug msg
          begin
            storage_account = @storage_mgmt_client.storage_accounts.get_properties(resource_group_name, storage_account_name)
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Storage Account #{storage_account_name} doesn't exist."
              return false
            else
              raise_azure_exception(e, msg)
            end
          end

          if storage_account.provisioning_state == 'Succeeded'
            Fog::Logger.debug "Storage Account #{storage_account_name} exists."
            true
          else
            Fog::Logger.debug "Storage Account #{storage_account_name} doesn't exist."
            false
          end
        end
      end
      # This class provides the mock implementation.
      class Mock
        def check_storage_account_exists(*)
          true
        end
      end
    end
  end
end
