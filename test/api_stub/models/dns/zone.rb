module ApiStub
  module Models
    module DNS
      # Mock class for Zone
      class Zone
        def self.create_zone_obj(dns_client)
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
          dns_client.deserialize(zone_mapper, Fog::JSON.decode(zone), 'result.body')
        end
      end
    end
  end
end
