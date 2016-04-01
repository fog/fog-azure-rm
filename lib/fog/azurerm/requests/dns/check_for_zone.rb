module Fog
  module DNS
    class AzureRM
      class Real
        def check_for_zone(dns_resource_group, zone_name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}?api-version=2015-05-04-preview"
          token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
          begin
            dns_response = RestClient.get(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token)
            dns_hash = JSON.parse(dns_response)
            if dns_hash.key?('id') && !dns_hash['id'].nil?
              true
            else
              false
            end
          rescue RestClient::Exception => e
            if e.http_code == 404
              false
            else
              body = JSON.parse(e.http_body)
              msg = "Exception checking if the zone exists: #{body['code']}, #{body['message']}"
              fail msg
            end
          end
        end
      end

      class Mock
        def create_zone(dns_resource_group, zone_name)

        end
      end
    end
  end
end
