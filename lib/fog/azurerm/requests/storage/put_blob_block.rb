module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def put_blob_block(container_name, blob_name, block_id, data, options = {})
          my_options = options.clone
          my_options[:request_id] = SecureRandom.uuid

          correlation_id = SecureRandom.uuid
          if my_options[:fog_correlation_id] != nil
            correlation_id = my_options.delete(:fog_correlation_id)
          end

          if my_options[:put_blob_block_timeout]
            Fog::Logger.debug "put_blob_block: Setting blob operation timeout to #{my_options[:put_blob_block_timeout]} seconds, correlation id: #{correlation_id}."
            my_options[:timeout] = my_options[:put_blob_block_timeout]
          else
            # Server side default is 10 minutes per megabyte on average, lets use an avg. speed of at least 100KiB/s
            default_timeout = MAXIMUM_CHUNK_SIZE / 102400
            Fog::Logger.debug "put_blob_block: Setting blob operation timeout to default of #{default_timeout} seconds, correlation id: #{correlation_id}."
            my_options[:timeout] = default_timeout
          end

          msg = "put_blob_block block_id: #{block_id} / #{blob_name} to the container #{container_name}. options: #{my_options}, correlation id: #{correlation_id}."
          Fog::Logger.debug msg

          begin
            @blob_client.put_blob_block(container_name, blob_name, block_id, data, my_options)
          rescue Azure::Core::Http::HTTPError => ex
            Fog::Logger.warning "Azure error #{e.inspect}, correlation id: #{correlation_id}."
            raise_azure_exception(ex, msg)
          rescue => e
            Fog::Logger.warning "Unknown error #{e.inspect}, correlation id: #{correlation_id}."
            raise e
          end

          Fog::Logger.debug "block_id #{block_id} is uploaded successfully, correlation id: #{correlation_id}."
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
