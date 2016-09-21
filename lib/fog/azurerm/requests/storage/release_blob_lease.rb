module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def release_blob_lease(container_name, name, lease_id, options={})
          msg = "Releasing blob: #{name} of container #{container_name} having lease_id #{lease_id}"
          Fog::Logger.debug msg
          begin
            @blob_client.release_blob_lease(container_name, name, lease_id, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug "Blob #{name} released successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def release_blob_lease(*)
          true
        end
      end
    end
  end
end
