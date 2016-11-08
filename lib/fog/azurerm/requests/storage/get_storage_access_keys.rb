module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def get_storage_access_keys(resource_group, storage_account_name, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "Getting storage access keys for storage account: #{storage_account_name}, #{options}."
          Fog::Logger.debug msg
          begin
            storage_account_keys = @storage_mgmt_client.storage_accounts.list_keys(resource_group, storage_account_name, options)
          rescue MsRestAzure::AzureOperationError => ex
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug "Storage access keys for storage account: #{storage_account_name} listed successfully."
          storage_account_keys.keys
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
