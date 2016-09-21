module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def copy_blob(destination_container, destination_blob, source_container, source_blob, options={})
          msg = "Copying blob: #{source_blob} from container #{source_container} to container #{destination_container}"
          Fog::Logger.debug msg
          begin
            copy_status = @blob_client.copy_blob(destination_container, destination_blob, source_container, source_blob, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug "Blob #{destination_blob} copied successfully."
          copy_status
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def copy_blob(*)
          {
            'copyId' => 'abc123',
            'copyStatus' => 'pending'
          }
        end
      end
    end
  end
end
