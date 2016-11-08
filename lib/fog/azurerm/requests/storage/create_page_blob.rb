module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_page_blob(container_name, blob_name, blob_size, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "create_page_blob #{blob_name} to the container #{container_name}. blob_size: #{blob_size}, options: #{options}"
          Fog::Logger.debug msg

          begin
            @blob_client.create_page_blob(container_name, blob_name, blob_size, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Page blob #{blob_name} created successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_page_blob(*)
          Fog::Logger.debug 'Page blob created successfully.'
          true
        end
      end
    end
  end
end
