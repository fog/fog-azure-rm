module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def get_record_set(resource_group, name, zone_name, record_type)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{name}?api-version=2015-05-04-preview"
          Fog::Logger.debug "Getting all records from RecordSet #{name} of type '#{record_type}' in zone #{zone_name}"

          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            dns_response = RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue Exception => e
            Fog::Logger.warning "Exception trying to get existing #{record_type} records for the record set: #{name}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end
          dns_hash = JSON.parse(dns_response)
          dns_hash
        end
      end

      # Mock class for DNS Request
      class Mock
        def get_record_set(resource_group, name, zone_name, record_type)
        end
      end
    end
  end
end
