module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_container_properties(name, options = {})
          Fog::Logger.debug "Get container properties: #{name}."
          begin
            container_properties = @blob_client.get_container_properties(name, options)
            Fog::Logger.debug "Getting properties of container #{name} successfully."
            container_properties
          rescue Azure::Core::Http::HTTPError => ex
            raise "Exception in getting properties of container #{name}: #{ex.inspect}"
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_container_properties(*)
          {
            'name' => 'testcontainer1',
            'properties' =>
              {
                'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
                'etag' => '0x8D3A3B5F017F52D',
                'lease_status' => 'unlocked',
                'lease_state' => 'available'
              },
            'metadata' => {}
          }
        end
      end
    end
  end
end
