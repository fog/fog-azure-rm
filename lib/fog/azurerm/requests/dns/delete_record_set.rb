module Fog
  module DNS
    class AzureRM
      class Real
        def delete_record_set(record_set_name, dns_resource_group, zone_name, record_type)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{record_set_name}?api-version=2015-05-04-preview"
          Fog::Logger.debug "Deleting RecordSet #{record_set_name} of type '#{record_type}' in zone #{zone_name}"

          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.delete(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token
            )
            Fog::Logger.debug "RecordSet #{record_set_name} Deleted Successfully!"
          rescue Exception => e
            if e.http_code == 404
              Fog::Logger.warning 'AzureDns::RecordSet - 404 code, trying to delete something that is not there.'
            else
              Fog::Logger.warning "Exception trying to remove #{record_type} records for the record set: #{record_set_name}"
              msg = "AzureDns::RecordSet - Exception is: #{e.message}"
              raise msg
            end
          end
        end
      end

      class Mock
        def delete_record_set(record_set_name, dns_resource_group, zone_name, record_type)

        end
      end
    end
  end
end