module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def put_blob_properties(container_name, name, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "Set Blob #{name} properties #{options} in container #{container_name}."
          Fog::Logger.debug msg

          begin
            @blob_client.set_blob_properties(container_name, name, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Setting properties of blob #{name} successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def put_blob_properties(container_name, name, options = {})
          Fog::Logger.debug "Set Blob #{name} properties #{options} in a container #{container_name} successfully."
          true
        end
      end
    end
  end
end
