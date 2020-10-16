module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def put_blob_block(container_name, blob_name, block_id, data, options = {})
          myOptions = options.clone
          myOptions[:request_id] = SecureRandom.uuid
          if myOptions[:put_blob_block_timeout] then
            Fog::Logger.debug "put_blob_block: Setting blob operation timeout to #{myOptions[:put_blob_block_timeout]} seconds"
            myOptions[:timeout] = myOptions[:put_blob_block_timeout] 
          else
            # Server side default is 10 minutes per megabyte on average, lets use an avg. speed of at least 100KiB/s
            defaultTimeout = MAXIMUM_CHUNK_SIZE / 102400
            Fog::Logger.debug "put_blob_block: Setting blob operation timeout to default of #{defaultTimeout} seconds"
            myOptions[:timeout] = defaultTimeout
          end

          msg = "put_blob_block block_id: #{block_id} / #{blob_name} to the container #{container_name}. options: #{myOptions}"
          Fog::Logger.debug msg

          begin
            @blob_client.put_blob_block(container_name, blob_name, block_id, data, myOptions)
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
