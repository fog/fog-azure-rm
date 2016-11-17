module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        # Get a public container url from Azure storage container
        #
        # @param container_name [String] Name of container
        #
        # @return [String] - url for container
        #
        def get_container_url(container_name, options = {})
          query = { 'comp' => 'list', 'restype' => 'container' }
          uri = @blob_client.generate_uri(container_name, query)

          if options[:scheme] == 'http'
            uri.to_s.gsub('https:', 'http:')
          else
            uri.to_s
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_container_url(_container_name, options = {})
          url = 'https://sa.blob.core.windows.net/test_container?comp=list&restype=container'
          url.gsub!('https:', 'http:') if options[:scheme] == 'http'
          url
        end
      end
    end
  end
end
