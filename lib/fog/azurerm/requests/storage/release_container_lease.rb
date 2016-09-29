module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def release_container_lease(name, lease_id, options={})
          msg = "Releasing container: #{name} having lease_id #{lease_id}"
          Fog::Logger.debug msg
          begin
            @blob_client.release_container_lease(name, lease_id, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug "Container #{name} released successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def release_container_lease(*)
          true
        end
      end
    end
  end
end
