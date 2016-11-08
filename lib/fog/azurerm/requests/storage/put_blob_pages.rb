module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def put_blob_pages(container_name, blob_name, start_range, end_range, data, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "put_blob_pages [#{start_range}-#{end_range}] / #{blob_name} to the container #{container_name}. options: #{options}"
          Fog::Logger.debug msg

          begin
            @blob_client.put_blob_pages(container_name, blob_name, start_range, end_range, data, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "[#{start_range}-#{end_range}] / #{blob_name} is uploaded successfully."
          true
        end
      end

      # This class provides the mock implementation.
      class Mock
        def put_blob_pages(*)
          true
        end
      end
    end
  end
end
