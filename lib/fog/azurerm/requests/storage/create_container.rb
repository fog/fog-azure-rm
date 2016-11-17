module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_container(name, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "Creating container: #{name}. options: #{options}"
          Fog::Logger.debug msg

          begin
            container = @blob_client.create_container(name, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Container #{name} created successfully."
          container
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_container(*)
          {
            'name' => 'test_container',
            'public_access_level' => nil,
            'metadata' => {},
            'properties' => {
              'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
              'etag' => '0x8D3A3B5F017F52D',
              'lease_status' => 'unlocked',
              'lease_state' => 'available'
            }
          }
        end
      end
    end
  end
end
