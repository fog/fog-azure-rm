module ApiStub
  module Requests
    module DNS
      # Mock class for Zone
      class Zone
        def self.rest_client_put_method_for_zone_resonse
          {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/dnszones/fog-test-zone.com',
              'name' => 'fog-test-zone.com',
              'type' => 'Microsoft.Network/dnszones',
              'etag' => '00000003-0000-0000-bd66-02b337a4d101',
              'location' => 'global',
              'tags' => {},
              'properties' =>
                  {
                      'maxNumberOfRecordSets' => 100_00,
                      'nameServers' => nil,
                      'numberOfRecordSets' => 2,
                      'parentResourceGroupName' => 'fog-test-rg'
                  },
              'resource_group' => 'fog-test-rg'
          }
        end

        def self.list_zones_response
        {
          'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/dnszones/fog-test-zone.com',
          'name' => 'fog-test-zone.com',
          'type' => 'Microsoft.Network/dnszones',
          'etag' => '00000003-0000-0000-bd66-02b337a4d101',
          'location' => 'global',
          'tags' => {},
          'properties' =>
            {
              'maxNumberOfRecordSets' => 100_00,
              'nameServers' => nil,
              'numberOfRecordSets' => 2,
              'parentResourceGroupName' => 'fog-test-rg'
            },
          'resource_group' => 'fog-test-rg'
        }
        end

        def self.get_zone_response
        {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/dnszones/fog-test-zone.com',
            'name' => 'fog-test-zone.com',
            'type' => 'Microsoft.Network/dnszones',
            'etag' => '00000003-0000-0000-bd66-02b337a4d101',
            'location' => 'global',
            'tags' => {},
            'properties' =>
                {
                    'maxNumberOfRecordSets' => 100_00,
                    'nameServers' => nil,
                    'numberOfRecordSets' => 2,
                    'parentResourceGroupName' => 'fog-test-rg'
                },
            'resource_group' => 'fog-test-rg'
        }
        end
      end
    end
  end
end
