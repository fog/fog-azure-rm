module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def set_blob_metadata(container_name, name, metadata)
          msg = "Setting Blob #{name} metadata in a container #{container_name}."
          Fog::Logger.debug msg
          begin
            @blob_client.set_blob_metadata(container_name, name, metadata)
            Fog::Logger.debug "Setting metadata of blob #{name} successfully."
            true
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def set_blob_metadata(*)
          Fog::Logger.debug "Set Blob metadata in a container successfully."
          true
        end
      end
    end
  end
end
