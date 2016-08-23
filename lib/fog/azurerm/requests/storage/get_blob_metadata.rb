module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_blob_metadata(container_name, name)
          msg = "Getting Blob #{name} metadata in container #{container_name}."
          Fog::Logger.debug msg
          begin
              blob = @blob_client.get_blob_metadata(container_name, name)
              Fog::Logger.debug "Getting metadata of blob #{name} successfully."
              blob.metadata
            rescue Azure::Core::Http::HTTPError => ex
              raise_azure_exception(ex, msg)
            end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def get_blob_metadata(*)
          {
            'container-name' => 'testcontainer1',
            'blob-name' => 'testblob',
            'category' => 'Images',
            'resolution' => 'High'
          }
        end
      end
    end
  end
end
