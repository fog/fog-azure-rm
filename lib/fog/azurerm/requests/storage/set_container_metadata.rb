module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def set_container_metadata(name, metadata)
          Fog::Logger.debug "Set Container #{name} metadata."
          begin
            @blob_client.set_container_metadata(name, metadata)
            Fog::Logger.debug "Setting metadata of container #{name} successfully."
            true
          rescue Exception => ex
            raise "Exception in setting metadata of Container #{name}: #{ex.message}"
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def set_container_metadata(name, metadata)
          Fog::Logger.debug "Set Container #{name} metadata #{metadata} successfully."
          true
        end
      end
    end
  end
end
