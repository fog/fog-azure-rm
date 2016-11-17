module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        # Get an expiring https blob url from Azure blob storage
        #
        # @param container_name [String] Name of container containing blob
        # @param blob_name [String] Name of blob to get expiring url for
        # @param expires [Time] An expiry time for this url
        #
        # @return [String] - https url for blob
        #
        # @see https://msdn.microsoft.com/en-us/library/azure/mt584140.aspx
        #
        def get_blob_https_url(container_name, blob_name, expires)
          relative_path = "#{container_name}/#{blob_name}"
          params = {
            service: 'b',
            resource: 'b',
            permissions: 'r',
            expiry: expires.utc.iso8601,
            protocol: 'https'
          }
          token = @signature_client.generate_service_sas_token(relative_path, params)
          uri = @blob_client.generate_uri(relative_path)
          "#{uri}?#{token}"
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_blob_https_url(*)
          'https://sa.blob.core.windows.net/test_container/test_blob?token'
        end
      end
    end
  end
end
