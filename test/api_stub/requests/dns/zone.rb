module ApiStub
  module Requests
    module DNS
      # Mock class for Zone
      class Zone
        def self.list_zones_response(dns_client)
          body = '{
            "value": [{
                       "id":"\/subscriptions\/########-####-####-####-############\/resourceGroups\/fog_test_rg\/providers\/Microsoft.Network\/dnszones\/adnaan.com",
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
          zone_mapper = Azure::ARM::Dns::Models::ZoneListResult.mapper
          dns_client.deserialize(zone_mapper, JSON.load(body), 'result.body').value
        end

        def self.zone_response(dns_client)
          zone = '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/dnszones/fog-test-zone.com",
            "name": "fog-test-zone.com",
            "type": "Microsoft.Network/dnszones",
            "etag": "00000003-0000-0000-bd66-02b337a4d101",
            "location": "global",
            "tags": {},
            "properties":
              {
                "maxNumberOfRecordSets": 100,
                "nameServers": [],
                "numberOfRecordSets": 2,
                "parentResourceGroupName": "fog-test-rg"
              },
            "resource_group": "fog-test-rg"
          }'
          zone_mapper = Azure::ARM::Dns::Models::Zone.mapper
          dns_client.deserialize(zone_mapper, JSON.load(zone), 'result.body')
        end
      end
    end
  end
end
