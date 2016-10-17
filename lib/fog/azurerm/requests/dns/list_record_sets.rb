module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def list_record_sets(resource_group, zone_name)
          msg = 'Getting list of Record sets.'
          Fog::Logger.debug msg
          begin
            zones = @dns_client.record_sets.list_all_in_resource_group(resource_group, zone_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          zones
        end
      end

      # Mock class for DNS Request
      class Mock
        def list_record_sets(*)
          [
            {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.Network/dnszones/zone_name/A/test_record',
              'name' => 'test_record',
              'type' => 'Microsoft.Network/dnszones/A',
              'etag' => '7f159cb1-653d-4920-bc03-153c700412a2',
              'location' => 'global',
              'properties' =>
              {
                'metadata' => nil,
                'fqdn' => 'test_record.zone_name',
                'TTL' => 60,
                'ARecords' =>
                [
                  {
                    'ipv4Address' => '1.2.3.4'
                  }
                ]
              }
            },
            {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.Network/dnszones/zone_name/CNAME/test_record1',
              'name' => 'test_record1',
              'type' => 'Microsoft.Network/dnszones/CNAME',
              'etag' => 'cc5ceb6e-16ad-4a5f-bbd7-9bc31c12d0cf',
              'location' => 'global',
              'properties' =>
              {
                'metadata' => nil,
                'fqdn' => 'test_record1.zone_name',
                'TTL' => 60,
                'CNAMERecord' =>
                {
                  'cname' => '1.2.3.4'
                }
              }
            }
          ]
        end
      end
    end
  end
end
