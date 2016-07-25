module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def get_zone(resource_group, name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{name}?api-version=2016-04-01"
          Fog::Logger.debug "Getting a zone: #{name}"

          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            dns_response = RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue Exception => e
            Fog::Logger.warning "Exception trying to get existing zone: #{name}."
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end
          dns_hash = JSON.parse(dns_response)
          dns_hash
        end
      end

      # Mock class for DNS Request
      class Mock
        def get_zone(resource_group, name)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnszones/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/dnszones',
            'etag' => '00000003-0000-0000-bd66-02b337a4d101',
            'location' => 'global',
            'tags' => {},
            'properties' =>
              {
                'maxNumberOfRecordSets' => 100_00,
                'nameServers' => nil,
                'numberOfRecordSets' => 2,
                'parentResourceGroupName' => resource_group
              },
            'resource_group' => resource_group
          }
        end
      end
    end
  end
end
