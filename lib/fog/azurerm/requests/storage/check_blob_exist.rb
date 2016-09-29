module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def check_blob_exist(container_name, name, options = {})
          Fog::Logger.debug "Check Blob #{name} exist in container #{container_name}."
          begin
            @blob_client.get_blob_properties(container_name, name, options)
          rescue Azure::Core::Http::HTTPError
            return false
          end
          Fog::Logger.debug "Blob #{name} Exists."
          true
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_blob_exist(*)
          true
        end
      end
    end
  end
end
