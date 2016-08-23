module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_container(name, options = {})
          msg = "Creating container: #{name}."
          Fog::Logger.debug msg
          begin
            container = @blob_client.create_container(name, options)
            Fog::Logger.debug "Container #{name} created successfully."
            container
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_container(*)
          {
            'name' => 'testcontainer1',
            'properties' =>
              {
                'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
                'etag' => '0x8D3A3B5F017F52D',
                'lease_status' => 'unlocked',
                'lease_state' => 'available'
              },
            'public_access_level' => nil,
            'metadata' => {}
          }
        end
      end
    end
  end
end
