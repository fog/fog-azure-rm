module Fog
  module DNS
    class AzureRM
      class Real
        def list_record_sets(dns_resource_group, zone_name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/recordsets?api-version=2015-05-04-preview"
          token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
          begin
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
              msg = "Exception fetching record_sets: #{body['code']}, #{body['message']}"
            else
              msg = "Exception fetching record_sets: #{body['code']}, #{body['message']}"
            end
            fail msg
          end
        end
      end

      class Mock
        def list_record_sets(dns_resource_group, zone_name)
          rset = {
            :name => 'fogtestrecordset',
            :resource_group => 'fog-test-resource-group',
            :zone_name => 'fogtestzone.com',
            :records => ['1.2.3.4', '1.2.3.3'],
            :type => 'A',
            :ttl => 60
          }
          [rset]
        end
      end
    end
  end
end