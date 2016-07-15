module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def set_blob_metadata(container_name, name, metadata)
          Fog::Logger.debug "Set Blob #{name} metadata in a container #{container_name}."
          begin
            @blob_client.set_blob_metadata(container_name, name, metadata)
            Fog::Logger.debug "Setting metadata of blob #{name} successfully."
            true
          rescue Azure::Core::Http::HTTPError => ex
            raise "Exception in setting metadata of Blob #{name}: #{ex.inspect}"
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def set_blob_metadata(container_name, name, metadata)
          Fog::Logger.debug "Set Blob #{name} metadata #{metadata} in a container #{container_name} successfully."
          true
        end
      end
    end
  end
end
