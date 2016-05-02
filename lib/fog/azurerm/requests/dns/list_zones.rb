module Fog
  module DNS
    class AzureRM
      class Real
        def list_zones
          zone_hash_array = []
          @resources.resource_groups.each do |rg|
            list_zones_by_rg(rg.name).each do |zone_hash|
              zone_hash['resource_group'] = rg.name              
              zone_hash_array << zone_hash
            end
          end
          zone_hash_array
        end

        private

        def list_zones_by_rg(dns_resource_group)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones?api-version=2015-05-04-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            dns_response = RestClient.get(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token)
            response_hash = JSON.parse(dns_response)
            response_hash['value']
          rescue RestClient::Exception => e
            body = JSON.parse(e.http_body)
            if body.key?('error')
              body = body['error']
              msg = "Exception fetching zones: #{body['code']}, #{body['message']}"
            else
              msg = "Exception fetching zones: #{body['code']}, #{body['message']}"
            end
            raise msg
          end
        end
      end

      class Mock
        def list_zones
          zone = {
            id: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-resource-group/Microsoft.Network/dnszones/fogtestzone.com',
            name: 'fogtestzone.com',
            resource_group: 'fog-test-resource-group'
          }
          [zone]
        end
      end
    end
  end
end
