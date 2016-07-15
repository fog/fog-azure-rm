module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_blob_metadata(container_name, name)
          Fog::Logger.debug "Get Blob #{name} metadata in container #{container_name}."
          begin
              blob = @blob_client.get_blob_metadata(container_name, name)
              Fog::Logger.debug "Getting metadata of blob #{name} successfully."
              blob.metadata
            rescue Azure::Core::Http::HTTPError => ex
              raise "Exception in getting metadata of Blob #{name}: #{ex.inspect}"
            end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def get_blob_metadata(container_name, name)
          {
            'container-name' => container_name,
            'blob-name' => name,
            'category' => 'Images',
            'resolution' => 'High'
          }
        end
      end
    end
  end
end
