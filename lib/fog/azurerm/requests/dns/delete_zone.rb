module Fog
  module DNS
    class AzureRM
      class Real

        def delete_zone(zone_name, dns_resource_group)
          Fog::Logger.debug "Deleting Zone #{zone_name} ..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}?api-version=2015-05-04-preview"
          token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
          begin
            RestClient.delete(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token)
            Fog::Logger.debug "Zone #{zone_name} deleted successfully."
            true
          rescue RestClient::Exception => e
            body = JSON.parse(e.http_body)
            if body.key?('error')
              body = body['error']
              msg = "Exception deleting zone: #{body['code']}, #{body['message']}"
            else
              msg = "Exception deleting zone: #{body['code']}, #{body['message']}"
            end
            fail msg
          end
        end
      end

      class Mock
        def delete_zone(zone_name, dns_resource_group)

        end
      end
    end
  end
end
