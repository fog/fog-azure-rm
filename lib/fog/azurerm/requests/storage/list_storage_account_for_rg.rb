# rubocop:disable LineLength
module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_storage_account_for_rg(resource_group)
          begin
            promise = @storage_mgmt_client.storage_accounts.list_by_resource_group(resource_group)
            response = promise.value!
            result = response.body.value
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Storage Accounts in Resource Group #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_storage_account_for_rg(resource_group)
        end
      end
    end
  end
end
