module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def delete_zone(resource_group, name)
          Fog::Logger.debug "Deleting Zone #{name} ..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{name}?api-version=2015-05-04-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.delete(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token)
            Fog::Logger.debug "Zone #{name} deleted successfully."
            true
          rescue Exception => e
            Fog::Logger.warning "Exception deleting zone #{name} from resource group #{resource_group}"
            msg = "AzureDns::Zone - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def delete_zone(_resource_group, _name)
          Fog::Logger.debug "Zone #{_name} deleted successfully."
          return true
        end
      end
    end
  end
end
