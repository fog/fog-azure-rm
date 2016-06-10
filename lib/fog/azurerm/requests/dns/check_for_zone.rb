module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def check_for_zone(resource_group, name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{name}?api-version=2015-05-04-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
            true
          rescue RestClient::Exception => e
            body = JSON.parse(e.response)
            if (body['error']['code']) == 'ResourceNotFound'
              false
            else
              Fog::Logger.warning "Exception checking if the zone exists in resource group #{resource_group}"
              msg = "Exception checking if the zone exists: #{body['error']['code']}, #{body['error']['message']}"
              raise msg
            end
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def check_for_zone(_resource_group, name)
          Fog::Logger.debug "Zone name #{name} is available."
          true
        end
      end
    end
  end
end
