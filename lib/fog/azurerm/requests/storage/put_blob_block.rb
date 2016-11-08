module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def put_blob_block(container_name, blob_name, block_id, data, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "put_blob_block block_id: #{block_id} / #{blob_name} to the container #{container_name}. options: #{options}"
          Fog::Logger.debug msg

          begin
            @blob_client.put_blob_block(container_name, blob_name, block_id, data, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "block_id #{block_id} is uploaded successfully."
          true
        end
      end

      # This class provides the mock implementation.
      class Mock
        def put_blob_block(*)
          true
        end
      end
    end
  end
end
