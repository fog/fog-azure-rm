module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_container(name)
          options = { request_id: SecureRandom.uuid }
          msg = "Deleting container: #{name}. options: #{options}"
          Fog::Logger.debug msg

          begin
            @blob_client.delete_container(name, options)
          rescue Azure::Core::Http::HTTPError => ex
            return true if ex.message.include?('(404)')
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Container #{name} deleted successfully."
          true
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
