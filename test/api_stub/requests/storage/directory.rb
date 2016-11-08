module ApiStub
  module Requests
    module Storage
      # Mock class for Deployment Requests
      # Below data should be as same as those in Mock classes in lib/fog/azurerm/requests/storage/*.rb
      class Directory
        def self.container
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

        def self.container_lease_id
          { 'leaseId' => 'abc123' }
        end

        def self.container_object
          container = Azure::Storage::Blob::Container::Container.new
          container.public_access_level = 'container'
          container
        end

        def self.raw_container_acl
          [container_object, {}]
        end

        def self.container_acl
          [container_object.public_access_level, {}]
        end

        def self.container_https_url
          'https://sa.blob.core.windows.net/test_container?comp=list&restype=container'
        end

        def self.container_metadata
          {
            'created-by' => 'User',
            'source-machine' => 'Test-machine',
            'category' => 'guidance',
            'doctype' => 'textDocuments'
          }
        end

        def self.container_list
          [
            {
              'name' => 'test_container1',
              'metadata' => {},
              'properties' => {
                'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
                'etag' => '0x8D3A3B5F017F52D',
                'lease_status' => 'unlocked',
                'lease_state' => 'available'
              }
            },
            {
              'name' => 'test_container2',
              'metadata' => {},
              'properties' => {
                'last_modified' => 'Tue, 04 Aug 2015 06:01:08 GMT',
                'etag' => '0x8D29C92176C8352',
                'lease_status' => 'unlocked',
                'lease_state' => 'available'
              }
            },
            {
              'name' => 'test_container3',
              'metadata' => {},
              'properties' => {
                'last_modified' => 'Tue, 01 Sep 2015 05:15:36 GMT',
                'etag' => '0x8D2B28C5EB36458',
                'lease_status' => 'unlocked',
                'lease_state' => 'available'
              }
            }
          ]
        end
      end
    end
  end
end
