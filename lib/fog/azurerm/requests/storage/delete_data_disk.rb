module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_data_disk(resource_group, storage_account_name, blob_name)
          Fog::Logger.debug "Deleting Data Disk: #{blob_name}."
          access_key = get_storage_access_key(resource_group, storage_account_name)
          client = Azure::Storage::Client.new(storage_account_name: storage_account_name, storage_access_key: access_key)
          blob_service = Azure::Storage::Blob::BlobService.new(client: client)
          begin
            result = blob_service.delete_blob('vhds', "#{blob_name}.vhd")
            if result.nil?
              Fog::Logger.debug "Successfully deleted Data Disk: #{blob_name}."
              true
            else
              Fog::Logger.debug 'Error deleting Data Disk.'
              false
            end
          rescue Azure::Core::Http::HTTPError => e
            msg = "Error deleting Data Disk. #{e.description}"
            raise msg
          end
        end

        private

        def get_storage_access_key(resource_group, storage_account_name)
          begin
            storage_account_keys = @storage_mgmt_client.storage_accounts.list_keys(resource_group, storage_account_name).value!
            storage_account_keys.body.key2
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error deleting Data Disk. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_data_disk(_resource_group, _storage_account_name, blob_name)
          Fog::Logger.debug "Deleting Data Disk: #{blob_name}."
          Fog::Logger.debug "Successfully deleted Data Disk: #{blob_name}."
          true
        end
      end
    end
  end
end
