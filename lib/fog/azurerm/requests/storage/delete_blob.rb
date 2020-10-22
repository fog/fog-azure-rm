module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_blob(container_name, blob_name, options = {})
          my_options = options.clone
          my_options[:request_id] = SecureRandom.uuid
          msg = "Deleting blob: #{blob_name} in container #{container_name}. options: #{my_options}"
          Fog::Logger.debug msg

          begin
            @blob_client.delete_blob(container_name, blob_name, my_options)
          rescue Azure::Core::Http::HTTPError => ex
            return true if ex.message.include?('(404)')
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Blob #{blob_name} deleted successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_blob(*)
          Fog::Logger.debug 'Blob deleted successfully.'
          true
        end
      end
    end
  end
end
