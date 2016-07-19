module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_disk(resource_group, storage_account_name, blob_name)
          Fog::Logger.debug "Deleting Disk: #{blob_name}."
          access_key = get_storage_access_keys(resource_group, storage_account_name)['key2']
          client = Azure::Storage::Client.new(storage_account_name: storage_account_name, storage_access_key: access_key)
          blob_service = Azure::Storage::Blob::BlobService.new(client: client)
          begin
            result = blob_service.delete_blob('vhds', "#{blob_name}.vhd")
            if result.nil?
              Fog::Logger.debug "Successfully deleted Disk: #{blob_name}."
              true
            else
              Fog::Logger.debug 'Error deleting Disk.'
              false
            end
          rescue Azure::Core::Http::HTTPError => e
            msg = "Error deleting Disk. #{e.description}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_disk(_resource_group, _storage_account_name, blob_name)
          Fog::Logger.debug "Deleting Disk: #{blob_name}."
          Fog::Logger.debug "Successfully deleted Disk: #{blob_name}."
          true
        end
      end
    end
  end
end
