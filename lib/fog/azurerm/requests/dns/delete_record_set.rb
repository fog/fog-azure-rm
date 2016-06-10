module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def delete_record_set(resource_group, name, zone_name, record_type)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{name}?api-version=2015-05-04-preview"
          Fog::Logger.debug "Deleting RecordSet #{name} of type '#{record_type}' in zone #{zone_name}"

          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.delete(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
            Fog::Logger.debug "RecordSet #{name} Deleted Successfully!"
            true
          rescue Exception => e
            Fog::Logger.warning "Exception deleting record set #{name} from resource group #{resource_group}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def delete_record_set(_resource_group, name, _zone_name, _record_type)
          Fog::Logger.debug "Record Set #{name} deleted successfully."
          true
        end
      end
    end
  end
end
