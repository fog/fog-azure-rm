module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_storage_account(resource_group, name)
          Fog::Logger.debug "Deleting Storage Account: #{name}."
          begin
           promise = @storage_mgmt_client.storage_accounts.delete(resource_group, name)
           response = promise.value!
           Fog::Logger.debug "Storage Account #{name} deleted successfully."
           response
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Storage Account #{name} in Resource Group #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_storage_account(resource_group, name)
        end
      end
    end
  end
end
