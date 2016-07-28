module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_blob(container_name, blob_name, options = {})
          Fog::Logger.debug "Deleting blob: #{blob_name} in container #{container_name}."
          begin
            @blob_client.delete_blob(container_name, blob_name, options)
            Fog::Logger.debug "Blob #{blob_name} deleted successfully."
            true
          rescue Azure::Core::Http::HTTPError => ex
            raise "Exception in deleting the blob #{blob_name}: #{ex.inspect}"
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_blob(*)
          true
        end
      end
    end
  end
end
