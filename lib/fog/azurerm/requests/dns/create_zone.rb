module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def create_zone(dns_resource_group, zone_name)
          Fog::Logger.debug "Creating Zone #{zone_name} ..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}?api-version=2015-05-04-preview"

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
              authorization: token)
            Fog::Logger.debug "Zone #{zone_name} created successfully."
            parsed_response = JSON.parse(response)
            parsed_response
          rescue Exception => e
            Fog::Logger.warning "Exception creating zone #{zone_name} in resource group #{dns_resource_group}"
            msg = "AzureDns::Zone - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def create_zone(_dns_resource_group, _zone_name)
          {
            "id" => "/subscriptions/########-####-####-####-############/resourceGroups/#{_dns_resource_group}/providers/Microsoft.Network/dnszones/#{_zone_name}",
            "name" => _zone_name,
            "type" => "Microsoft.Network/dnszones",
            "etag" => "00000002-0000-0000-76c2-f7ad90b5d101",
            "location" => "global",
            "tags" => {},
            "properties" =>
              {
                "maxNumberOfRecordSets" => 5000,
                "nameServers" =>
                [
                  "ns1-05.azure-dns.com.",
                  "ns2-05.azure-dns.net.",
                  "ns3-05.azure-dns.org.",
                  "ns4-05.azure-dns.info."
                ],
                "numberOfRecordSets" => 2,
                "parentResourceGroupName" => _dns_resource_group
              }
          }

        end
      end
    end
  end
end
