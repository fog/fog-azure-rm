module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_containers(options = {})
          msg = 'Listing containers.'
          Fog::Logger.debug msg
          begin
            containers = @blob_client.list_containers(options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug 'Listing containers successfully.'
          containers
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def list_containers(*)
          [
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
            },
            {
              'name' => 'testcontainer2',
              'properties' =>
                {
                  'last_modified' => 'Tue, 04 Aug 2015 06:01:08 GMT',
                  'etag' => '0x8D29C92176C8352',
                  'lease_status' => 'unlocked',
                  'lease_state' => 'available'
                },
              'metadata' => {}
            }
          ]
        end
      end
    end
  end
end
