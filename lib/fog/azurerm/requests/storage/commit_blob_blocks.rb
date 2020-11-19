module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def commit_blob_blocks(container_name, blob_name, blocks, options = {})
          my_options = options.clone
          my_options[:request_id] = SecureRandom.uuid

          correlation_id = SecureRandom.uuid
          correlation_id = my_options.delete(:fog_correlation_id) unless my_options[:fog_correlation_id].nil?

          msg = "commit_blob_blocks: Complete uploading #{blob_name} to the container #{container_name}. options: #{my_options}, correlation id: #{correlation_id}."
          Fog::Logger.debug msg

          begin
            @blob_client.commit_blob_blocks(container_name, blob_name, blocks, my_options)
          rescue Azure::Core::Http::HTTPError => ex
            Fog::Logger.warning "Azure error #{e.inspect}, correlation id: #{correlation_id}."
            raise_azure_exception(ex, msg)
          rescue StandardError => e
            Fog::Logger.warning "Unknown error #{e.inspect}, correlation id: #{correlation_id}."
            raise e
          end

          Fog::Logger.debug "Block blob #{blob_name} is uploaded successfully, correlation id: #{correlation_id}."
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
