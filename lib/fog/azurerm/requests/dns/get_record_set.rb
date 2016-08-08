module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def get_record_set(resource_group, name, zone_name, record_type)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{name}?api-version=2015-05-04-preview"
          Fog::Logger.debug "Getting a RecordSet #{name} of type '#{record_type}' in zone #{zone_name}"

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
          JSON.parse(dns_response)
        end
      end

      # Mock class for DNS Request
      class Mock
        def get_record_set(resource_group, name, zone_name, record_type)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnszones/#{zone_name}/#{record_type}/#{name}",
            'name' => name,
            'type' => "Microsoft.Network/dnszones/#{record_type}",
            'etag' => '3376a38f-a53f-4ed0-a2e7-dfaba67dbb40',
            'location' => 'global',
            'properties' =>
              {
                'metadata' => nil,
                'fqdn' => "#{name}.#{zone_name}.",
                'TTL' => 60,
                'ARecords' =>
                  [
                    {
                      'ipv4Address' => '1.2.3.4'
                    },
                    {
                      'ipv4Address' => '1.2.3.3'
                    }
                  ]
              }
          }
        end
      end
    end
  end
end
