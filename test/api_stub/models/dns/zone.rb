module ApiStub
  module Models
    module DNS
      # Mock class for Zone
      class Zone
        # This class contain two mocks, for collection and for model
        def self.list_zones
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

        def self.create_zone_obj
          zone_obj = Fog::DNS::AzureRM::Zone.new
          zone_obj.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/dnszones/fog-test-zone.com'
          zone_obj.name = 'fog-test-zone.com'
          zone_obj.resource_group = 'fog-test-rg'
          zone_obj
        end
      end
    end
  end
end
