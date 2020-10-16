module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def commit_blob_blocks(container_name, blob_name, blocks, options = {})
          my_options = options.clone
          my_options[:request_id] = SecureRandom.uuid
          msg = "commit_blob_blocks: Complete uploading #{blob_name} to the container #{container_name}. options: #{my_options}"
          Fog::Logger.debug msg

          begin
            @blob_client.commit_blob_blocks(container_name, blob_name, blocks, my_options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Block blob #{blob_name} is uploaded successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def commit_blob_blocks(*)
          true
        end
      end
    end
  end
end
