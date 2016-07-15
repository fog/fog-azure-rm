module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_container(name, options = {})
          Fog::Logger.debug "Deleting container: #{name}."
          begin
            @blob_client.delete_container(name, options)
            Fog::Logger.debug "Container #{name} deleted successfully."
            true
          rescue Azure::Core::Http::HTTPError => ex
            raise "Exception in deleting the container #{name}: #{ex.inspect}"
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_container(*)
          true
        end
      end
    end
  end
end
