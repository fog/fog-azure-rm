module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def list_zones
          msg = 'Getting list of Zones.'
          Fog::Logger.debug msg
          begin
            zones = @dns_client.zones.list_in_subscription
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          zones
        end

        private

        def list_zones_by_rg(resource_group)
          msg = "Getting list of Zones in Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            zones = @dns_client.zones.list_in_resource_group(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          zones
        end
      end

      # Mock class for DNS Request
      class Mock
        def list_zones
          [
            {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog_test_rg/providers/Microsoft.Network/dnszones/testfog1.com',
              'name' => 'testfog1.com',
              'type' => 'Microsoft.Network/dnszones',
              'etag' =>  '00000002-0000-0000-76c2-f7ad90b5d101',
              'location' => 'global',
              'tags' => {},
              'properties' =>
              {
                'maxNumberOfRecordSets' => 5000,
                'nameServers' =>
                  %w('ns1-05.azure-dns.com.', 'ns2-05.azure-dns.net.', 'ns3-05.azure-dns.org.', 'ns4-05.azure-dns.info.'),
                'numberOfRecordSets' => 2,
                'parentResourceGroupName' => 'fog_test_rg'
              }
            },
            {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog_test_rg/providers/Microsoft.Network/dnszones/testfog.com',
              'name' => 'testfog.com',
              'type' => 'Microsoft.Network/dnszones',
              'etag' => '00000002-0000-0000-4215-c21c8fb5d101',
              'location' => 'global',
              'tags' => {},
              'properties' =>
              {
                'maxNumberOfRecordSets' => 5000,
                'nameServers' =>
                  %w('ns1-02.azure-dns.com.', 'ns2-02.azure-dns.net.', 'ns3-02.azure-dns.org.', 'ns4-02.azure-dns.info.'),
                'numberOfRecordSets' => 2,
                'parentResourceGroupName' => 'fog_test_rg'
              }
            }
          ]
        end
      end
    end
  end
end
