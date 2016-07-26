module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def create_or_update_zone(resource_group, name)
          Fog::Logger.debug "Creating/Updating Zone #{name} ..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{name}?api-version=2015-05-04-preview"

          body = {
            location: 'global',
            tags: {},
            properties: {}
          }

          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.put(
              resource_url,
              body.to_json,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
            Fog::Logger.debug "Zone #{name} created successfully."
            parsed_response = JSON.parse(response)
            parsed_response
          rescue Exception => e
            Fog::Logger.warning "Exception creating zone #{name} in resource group #{resource_group}"
            msg = "AzureDns::Zone - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def create_or_update_zone(resource_group, name)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnszones/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/dnszones',
            'etag' => '00000002-0000-0000-76c2-f7ad90b5d101',
            'location' => 'global',
            'tags' => {},
            'properties' =>
              {
                'maxNumberOfRecordSets' => 5000,
                'nameServers' =>
                [
                  'ns1-05.azure-dns.com.',
                  'ns2-05.azure-dns.net.',
                  'ns3-05.azure-dns.org.',
                  'ns4-05.azure-dns.info.'
                ],
                'numberOfRecordSets' => 2,
                'parentResourceGroupName' => resource_group
              }
          }
        end
      end
    end
  end
end
