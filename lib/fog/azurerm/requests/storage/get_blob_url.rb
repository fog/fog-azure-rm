module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        # Get a public blob url from Azure blob storage
        def get_blob_url(container_name, blob_name, options = {})
          uri = @blob_client.generate_uri("#{container_name}/#{blob_name}")

          if options[:scheme] == 'http'
            uri.to_s.gsub('https:', 'http:')
          else
            uri.to_s
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_blob_url(_container_name, _blob_name, options = {})
          url = 'https://sa.blob.core.windows.net/test_container/test_blob'
          url.gsub!('https:', 'http:') if options[:scheme] == 'http'
          url
        end
      end
    end
  end
end
