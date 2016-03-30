module Fog
  module DNS
    class AzureRM
      class Real

        def create_zone(dns_resource_group, zone_name)
          create(dns_resource_group, zone_name)
        end

        private

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

        def create(dns_resource_group, zone_name)
          if check_for_zone(dns_resource_group, zone_name)
            puts "Zone #{zone_name} Exists, no need to create"
            return
          end

          puts "Creating Zone #{zone_name} ..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}?api-version=2015-05-04-preview"
          token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
          body = {
              location: 'global',
              tags: {},
              properties: {} }
          begin
            dns_response = RestClient.put(
                resource_url,
                body.to_json,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token)
            response_hash = JSON.parse(dns_response)
            puts "Zone #{zone_name} created successfully."
            response_hash
          rescue RestClient::Exception => e
            body = JSON.parse(e.http_body)
            if body.key?('error')
              body = body['error']
              msg = "Exception creating zone: #{body['code']}, #{body['message']}"
            else
              msg = "Exception creating zone: #{body['code']}, #{body['message']}"
            end

            fail msg
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
