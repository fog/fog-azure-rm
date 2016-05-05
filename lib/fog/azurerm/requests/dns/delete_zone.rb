module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def delete_zone(zone_name, dns_resource_group)
          Fog::Logger.debug "Deleting Zone #{zone_name} ..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}?api-version=2015-05-04-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.delete(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token)
            Fog::Logger.debug "Zone #{zone_name} deleted successfully."
            true
          rescue => e
            Fog::Logger.warning "Exception deleting zone #{zone_name} from resource group #{dns_resource_group}"
            msg = "AzureDns::Zone - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def delete_zone(_zone_name, _dns_resource_group)
        end
      end
    end
  end
end
