module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def list_zones
          zone_hash_array = []
          @resources.resource_groups.each do |rg|
            list_zones_by_rg(rg.name).each do |zone_hash|
              zone_hash_array << zone_hash
            end
          end
          zone_hash_array
        end

        private

        def list_zones_by_rg(resource_group)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones?api-version=2015-05-04-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            dns_response = RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token)
            parsed_zone = JSON.parse(dns_response)
            parsed_zone['value']
          rescue Exception => e
            Fog::Logger.warning "Exception listing zones in resource group #{resource_group}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def list_zones
          [
            {
              "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/fog_test_rg/providers/Microsoft.Network/dnszones/testfog1.com",
              "name"=>"testfog1.com",
              "type"=>"Microsoft.Network/dnszones",
              "etag"=> "00000002-0000-0000-76c2-f7ad90b5d101",
              "location"=>"global",
              "tags"=>{},
              "properties"=>
                {
                  "maxNumberOfRecordSets"=>5000,
                  "nameServers"=>
                    [
                      "ns1-05.azure-dns.com.",
                      "ns2-05.azure-dns.net.",
                      "ns3-05.azure-dns.org.",
                      "ns4-05.azure-dns.info."
                    ],
                  "numberOfRecordSets"=>2,
                  "parentResourceGroupName"=>"fog_test_rg"
                }
            },
            {
              "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/fog_test_rg/providers/Microsoft.Network/dnszones/testfog.com",
              "name"=>"testfog.com",
              "type"=>"Microsoft.Network/dnszones",
              "etag"=>"00000002-0000-0000-4215-c21c8fb5d101",
              "location"=>"global",
              "tags"=>{},
              "properties"=>
                {
                  "maxNumberOfRecordSets"=>5000,
                  "nameServers"=>
                    [
                      "ns1-02.azure-dns.com.",
                      "ns2-02.azure-dns.net.",
                      "ns3-02.azure-dns.org.",
                      "ns4-02.azure-dns.info."
                    ],
                  "numberOfRecordSets"=>2,
                  "parentResourceGroupName"=>"fog_test_rg"
                }
              }
            ]
        end
      end
    end
  end
end
