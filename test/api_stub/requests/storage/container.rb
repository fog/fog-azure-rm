module ApiStub
  module Requests
    module Storage
      # Mock class for Deployment Requests
      class Container
        def self.test_get_container_metadata
          container = Azure::Storage::Blob::Container::Container.new
          container.name = 'test-container'
          container.metadata = metadata_response
          container
        end

        def self.metadata_response
          {
            'container-name' => 'Test-container',
            'created-by' => 'User',
            'source-machine' => 'Test-machine',
            'category' => 'guidance',
            'doctype' => 'textDocuments'
          }
        end

        def self.create_container
          {
            'name' => 'testcontainer1',
            'properties' =>
              {
                'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
                'etag' => '0x8D3A3B5F017F52D'
              }
          }
        end

        def self.list_containers
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
            },
            {
              'name' => 'testcontainer3',
              'properties' =>
                {
                  'last_modified' => 'Tue, 01 Sep 2015 05:15:36 GMT',
                  'etag' => '0x8D2B28C5EB36458',
                  'lease_status' => 'unlocked',
                  'lease_state' => 'available'
                },
              'metadata' => {}
            }
          ]
        end

        def self.get_container_properties
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

        def self.get_container_access_control_list
          [{
            'name' => 'testcontainer1',
            'public_access_level' => 'blob'
          }, {}]
        end
      end
    end
  end
end
