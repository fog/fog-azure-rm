module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def create_or_update_zone(zone_params)
          msg = "Creating/updating Zone #{zone_params[:name]} in Resource Group: #{zone_params[:resource_group]}."
          Fog::Logger.debug msg
          zone_object = get_zone_object(zone_params)
          begin
            zone = @dns_client.zones.create_or_update(zone_params[:resource_group], zone_params[:name], zone_object)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Zone #{zone_params[:name]} created/updated successfully."
          zone
        end

        private

        def get_zone_object(zone_params)
          zone = Azure::ARM::Dns::Models::Zone.new
          zone.name = zone_params[:name]
          zone.location = zone_params[:location]
          zone.type = zone_params[:type]
          zone.number_of_record_sets = zone_params[:number_of_record_sets]
          zone.max_number_of_record_sets = zone_params[:max_number_of_record_sets]
          zone.tags = zone_params[:tags]
          zone.etag = zone_params[:etag]
          zone
        end
      end

      # Mock class for DNS Request
      class Mock
        def create_or_update_zone(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.Network/dnszones/name',
            'name' => 'name',
            'type' => 'Microsoft.Network/dnszones',
            'etag' => '00000002-0000-0000-76c2-f7ad90b5d101',
            'location' => 'global',
            'tags' => {},
            'properties' =>
              {
                'maxNumberOfRecordSets' => 5000,
                'nameServers' => %w(ns1-05.azure-dns.com. ns2-05.azure-dns.net. ns3-05.azure-dns.org. ns4-05.azure-dns.info.),
                'numberOfRecordSets' => 2,
                'parentResourceGroupName' => 'zone.resource_group'
              }
          }
        end
      end
    end
  end
end
