module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def list_record_sets(dns_resource_group, zone_name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/recordsets?api-version=2015-05-04-preview"
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
            Fog::Logger.warning "Exception listing recordsets in zone #{zone_name} in resource group #{dns_resource_group}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def list_record_sets(_dns_resource_group, _zone_name)
          [
            {
              "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/#{_dns_resource_group}/providers/Microsoft.Network/dnszones/#{_zone_name}/A/test_record",
              "name"=>"test_record",
              "type"=>"Microsoft.Network/dnszones/A",
              "etag"=>"7f159cb1-653d-4920-bc03-153c700412a2",
              "location"=>"global",
              "properties"=>
                {
                  "metadata"=>nil,
                  "fqdn"=>"test_record.#{_zone_name}.",
                  "TTL"=>60,
                  "ARecords"=>
                    [
                      {
                        "ipv4Address"=>"1.2.3.4"
                      }
                    ]
                }
            },
            {
              "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/#{_dns_resource_group}/providers/Microsoft.Network/dnszones/#{_zone_name}/CNAME/test_record1",
              "name"=>"test_record1",
              "type"=>"Microsoft.Network/dnszones/CNAME",
              "etag"=>"cc5ceb6e-16ad-4a5f-bbd7-9bc31c12d0cf",
              "location"=>"global",
              "properties"=>
                {
                  "metadata"=>nil,
                  "fqdn"=>"test_record1.#{_zone_name}.",
                  "TTL"=>60,
                  "CNAMERecord"=>
                    {
                      "cname"=>"1.2.3.4"
                    }
                }
            }
          ]
        end
      end
    end
  end
end
