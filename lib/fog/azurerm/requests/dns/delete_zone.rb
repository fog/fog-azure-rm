module Fog
  module DNS
    class AzureRM
      class Real

        def delete_zone(zone_name, dns_resource_group)
          delete(dns_resource_group, zone_name)
        end

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

        def delete(dns_resource_group, zone_name)
          unless check_for_zone(dns_resource_group, zone_name)
            puts "Zone #{zone_name} does not exist, no need to delete"
            return
          end

          puts "Deleting Zone #{zone_name} ..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}?api-version=2015-05-04-preview"
          token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
          begin
            RestClient.delete(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token)
            puts "Zone #{zone_name} deleted successfully."
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
