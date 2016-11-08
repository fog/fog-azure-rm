module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def put_blob_metadata(container_name, name, metadata, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "Setting Blob #{name} metadata in a container #{container_name}. options: #{options}"
          Fog::Logger.debug msg

          begin
            @blob_client.set_blob_metadata(container_name, name, metadata, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Setting metadata of blob #{name} successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def put_blob_metadata(container_name, name, metadata, _options = {})
          Fog::Logger.debug "Set Blob #{name} metadata #{metadata} in a container #{container_name} successfully."
          true
        end
      end
    end
  end
end
