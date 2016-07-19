module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_storage_access_keys(resource_group, storage_account_name, options = {})
          Fog::Logger.debug "Getting storage access keys for storage account: #{storage_account_name}."
          begin
            storage_account_keys = @storage_mgmt_client.storage_accounts.list_keys(resource_group, storage_account_name, options).value!
            Fog::Logger.debug "Storage access keys for storage account: #{storage_account_name} listed successfully."
            Azure::ARM::Storage::Models::StorageAccountKeys.serialize_object(storage_account_keys.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error getting storage access keys. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation.
      class Mock
        def get_storage_access_keys(_resource_group, storage_account_name, _options = {})
          Fog::Logger.debug "Getting storage access keys for storage account: #{storage_account_name}."
          Fog::Logger.debug "Storage access keys for storage account: #{storage_account_name} listed successfully."
          {
            'key1' => 'key1 value',
            'key2' => 'key2 value'
          }
        end
      end
    end
  end
end
