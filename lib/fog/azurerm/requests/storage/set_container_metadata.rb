module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def set_container_metadata(name, metadata)
          msg = "Setting Container #{name} metadata."
          Fog::Logger.debug msg
          begin
            @blob_client.set_container_metadata(name, metadata)
            Fog::Logger.debug "Setting metadata of container #{name} successfully."
            true
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def set_container_metadata(*)
          Fog::Logger.debug "Set Container testcontainer1 metadata successfully."
          true
        end
      end
    end
  end
end
