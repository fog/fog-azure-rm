module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_storage_account(resource_group, name)
          msg = "Deleting Storage Account: #{name} in Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            @storage_mgmt_client.storage_accounts.delete(resource_group, name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Storage Account #{name} deleted successfully."
          true
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_storage_account(resource_group, name)
          Fog::Logger.debug "Storage Account #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
