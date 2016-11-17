module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def get_storage_account(resource_group_name, storage_account_name)
          msg = "Getting storage account: #{storage_account_name}."
          Fog::Logger.debug msg
          begin
            storage_account = @storage_mgmt_client.storage_accounts.get_properties(resource_group_name, storage_account_name)
          rescue MsRestAzure::AzureOperationError => ex
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug "Getting storage account: #{storage_account_name} successfully."
          storage_account
        end
      end
      # This class provides the mock implementation.
      class Mock
        def get_storage_account(*)
          storage_account_hash = {
            'id' => '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fog_test_rg/providers/Microsoft.Storage/storageAccounts/fogtestsasecond',
            'name' => 'fog-test-storage-account',
            'location' => 'west us',
            'sku' =>
                {
                  'name' => 'Standard_LRS'
                }
          }
          storage_account_mapper = Azure::ARM::Storage::Models::StorageAccount.mapper
          storage_mgmt_client.deserialize(storage_account_mapper, storage_account_hash, 'hash')
        end
      end
    end
  end
end
