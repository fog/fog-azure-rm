module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def list_record_sets(dns_resource_group, zone_name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/recordsets?api-version=2015-05-04-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            dns_response = RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token)
            parsed_zone = JSON.parse(dns_response)
            parsed_zone['value']
          rescue Exception => e
            Fog::Logger.warning "Exception listing recordsets in zone #{zone_name} in resource group #{dns_resource_group}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def list_record_sets(_dns_resource_group, _zone_name)
          rset = {
            name: 'fogtestrecordset',
            resource_group: 'fog-test-resource-group',
            zone_name: 'fogtestzone.com',
            records: ['1.2.3.4', '1.2.3.3'],
            type: 'A',
            ttl: 60
          }
          [rset]
        end
      end
    end
  end
end
