module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def copy_blob_from_uri(destination_container, destination_blob, source_blob_uri, options={})
          msg = "Copying blob: #{source_blob_uri} to container #{destination_container}"
          Fog::Logger.debug msg
          begin
            copy_status = @blob_client.copy_blob_from_uri(destination_container, destination_blob, source_blob_uri, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug "Blob #{destination_blob} copied successfully."
          copy_status
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def copy_blob_from_uri(*)
          {
              'copyId' => 'abc123',
              'copyStatus' => 'pending'
          }
        end
      end
    end
  end
end
