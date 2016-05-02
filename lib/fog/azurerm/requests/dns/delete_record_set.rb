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
            true
          rescue RestClient::Exception => e
            body = JSON.parse(e.http_body)
            if body.key?('error')
              body = body['error']
              msg = "Exception deleting zone: #{body['code']}, #{body['message']}"
            else
              msg = "Exception deleting zone: #{body['code']}, #{body['message']}"
            end
            raise msg
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