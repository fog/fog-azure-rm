module Fog
  module DNS
    class AzureRM
      class Real
        def create_zone(dns_resource_group, zone_name)
          Fog::Logger.debug "Creating Zone #{zone_name} ..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}?api-version=2015-05-04-preview"
          
          body = {
              location: 'global',
              tags: {},
              properties: {}
          }

          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            dns_response = RestClient.put(
                resource_url,
                body.to_json,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token)
            response_hash = JSON.parse(dns_response)
            Fog::Logger.debug "Zone #{zone_name} created successfully."
            response_hash
          rescue RestClient::Exception => e
            body = JSON.parse(e.http_body)
            if body.key?('error')
              body = body['error']
              msg = "Exception creating zone: #{body['code']}, #{body['message']}"
            else
              msg = "Exception creating zone: #{body['code']}, #{body['message']}"
            end

            raise msg
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
