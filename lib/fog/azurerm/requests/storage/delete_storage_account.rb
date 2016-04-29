# rubocop:disable LineLength
module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_storage_account(resource_group, name)
          begin
           promise = @storage_mgmt_client.storage_accounts.delete(resource_group, name)
           promise.value!
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
