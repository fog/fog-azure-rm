module ApiStub
  module Requests
    module DNS
      # Mock class for Zone
      class Zone
        def self.rest_client_put_method_for_zone_resonse
          '{
             "id":"\/subscriptions\/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb\/resourceGroups\/fog_test_rg\/providers\/Microsoft.Network\/dnszones\/adnaan.com",
              "name":"adnaan.com",
              "type":"Microsoft.Network\/dnszones",
              "etag":"00000011-0000-0000-19f2-3a6c32b0d101",
              "location":"global",
              "tags":{},
              "properties":
                          {
                              "maxNumberOfRecordSets":5000,
                              "nameServers":null,
                              "numberOfRecordSets":2,
                              "parentResourceGroupName":"fog_test_rg"
                          },
              "resource_group":"fog-test-rg"
            }'
        end

        def self.list_zones_response
          '{
            "value": [{
                       "id":"\/subscriptions\/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb\/resourceGroups\/fog_test_rg\/providers\/Microsoft.Network\/dnszones\/adnaan.com",
                        "name":"adnaan.com",
                        "type":"Microsoft.Network\/dnszones",
                        "etag":"00000011-0000-0000-19f2-3a6c32b0d101",
                        "location":"global",
                        "tags":{},
                        "properties":
                                    {
                                        "maxNumberOfRecordSets":5000,
                                        "nameServers":null,
                                        "numberOfRecordSets":2,
                                        "parentResourceGroupName":"fog_test_rg"
                                    },
                        "resource_group":"fog-test-rg"
                        }]
            }'
        end

        def self.zone_response
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
