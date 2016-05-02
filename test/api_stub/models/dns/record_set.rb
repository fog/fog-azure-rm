module ApiStub
  module Models
    module DNS
      # Mock class for Record Set
      class RecordSet
        # This class contain two mocks, for collection and for model
        def self.list_record_sets
          {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/dnszones/fog-test-zone.com/A/fog-test-record_set',
              'name' => 'fog-test-record_set',
              'type' => 'Microsoft.Network/dnszones/A',
              'etag' => '3376a38f-a53f-4ed0-a2e7-dfaba67dbb40',
              'location' => 'global',
              'properties' =>
              {
                  'metadata' => nil,
                  'fqdn' => 'fog-test-record_set.fog-test-zone.com.',
                  'TTL' => 60,
                  'ARecords' =>
                      [
                          {
                              'ipv4Address' => '1.2.3.4'
                          },
                          {
                              'ipv4Address' => '1.2.3.3'
                          }
                      ]
              }
          }
        end

        def self.create_record_set_obj
          record_set_obj = Fog::DNS::AzureRM::RecordSet.new
          record_set_obj.name = 'fog-test-record_set'
          record_set_obj.resource_group = 'fog-test-rg'
          record_set_obj.zone_name = 'fog-test-zone.com'
          record_set_obj.records = ['1.2.3.4', '1.2.3.3']
          record_set_obj.type = 'A'
          record_set_obj.ttl = 60
          record_set_obj
        end
      end
    end
  end
end
