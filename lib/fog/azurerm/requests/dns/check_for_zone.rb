module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
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
            if dns_response.key?('id') && !dns_response['id'].nil?
              true
            else
              false
            end
          rescue => e
            Fog::Logger.warning "Exception checking if the zone #{name} exists in resource group #{resource_group}"
            msg = "AzureDns::Zone - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def check_for_zone(_resource_group, _name)
        end
      end
    end
  end
end
