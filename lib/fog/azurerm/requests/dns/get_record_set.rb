module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def get_record_set(resource_group, name, zone_name, record_type)
          msg = "Getting Record Set #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            record_set = @dns_client.record_sets.get(resource_group, zone_name, name, record_type)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          record_set
        end
      end

      # Mock class for DNS Request
      class Mock
        def get_record_set(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.Network/dnszones/zone_name/record_type/name',
            'name' => 'name',
            'type' => 'Microsoft.Network/dnszones/record_type',
            'etag' => '3376a38f-a53f-4ed0-a2e7-dfaba67dbb40',
            'location' => 'global',
            'properties' =>
              {
                'metadata' => nil,
                'fqdn' => 'name.zone_name',
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
      end
    end
  end
end
