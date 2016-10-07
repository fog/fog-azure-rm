module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def get_zone(resource_group, name)
          msg = "Getting Zone #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            zone = @dns_client.zones.get(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          zone
        end
      end

      # Mock class for DNS Request
      class Mock
        def get_zone(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.Network/dnszones/zone_name',
            'name' => 'zone_name',
            'type' => 'Microsoft.Network/dnszones',
            'etag' => '00000003-0000-0000-bd66-02b337a4d101',
            'location' => 'global',
            'tags' => {},
            'properties' =>
              {
                'maxNumberOfRecordSets' => 100_00,
                'nameServers' => nil,
                'numberOfRecordSets' => 2,
                'parentResourceGroupName' => 'resource_group'
              },
            'resource_group' => 'resource_group'
          }
        end
      end
    end
  end
end
