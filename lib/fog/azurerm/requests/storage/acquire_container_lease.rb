module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def acquire_container_lease(name, options={})
          msg = "Leasing container: #{name}"
          Fog::Logger.debug msg
          begin
            lease_id = @blob_client.acquire_container_lease(name, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug "Container #{name} leased successfully."
          lease_id
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def acquire_container_lease(*)
          {
            'leaseId' => 'abc123'
          }
        end
      end
    end
  end
end
