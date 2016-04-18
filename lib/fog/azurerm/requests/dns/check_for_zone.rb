module Fog
  module DNS
    class AzureRM
      class Real
        def check_for_zone(resource_group, name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{name}?api-version=2015-05-04-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
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
        def check_for_zone(resource_group, name)

        end
      end
    end
  end
end
