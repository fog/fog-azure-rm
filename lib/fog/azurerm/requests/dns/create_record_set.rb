module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def create_record_set(resource_group, name, zone_name, records, record_type, ttl)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{name}?api-version=2015-05-04-preview"
          Fog::Logger.debug "Creating/Updating RecordSet #{name} of type '#{record_type}' in zone #{zone_name}"

          case record_type
          when 'A'
            a_type_records_array = []
            records.each do |ip|
              a_type_records_array.push(ipv4Address: ip)
            end
            body = {
              location: 'global',
              tags: '',
              properties: {
                TTL: ttl,
                ARecords: a_type_records_array
              }
            }
          when 'CNAME'
            body = {
              location: 'global',
              tags: '',
              properties: {
                TTL: ttl,
                CNAMERecord: {
                  cname: records.first # because cname only has 1 value and we know the object is an array passed in.
                }
              }
            }
          end

          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.put(
              resource_url,
              body.to_json,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
            Fog::Logger.debug "RecordSet #{name} Created/Updated Successfully!"
            parsed_response = JSON.parse(response)
            parsed_response
          rescue Exception => e
            Fog::Logger.warning "Exception creating recordset #{name} in zone #{zone_name}."
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            raise msg
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def create_record_set(resource_group, name, zone_name, records, record_type, ttl)
          if record_type == 'A'
            {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnszones/#{zone_name}/#{record_type}/#{name}",
              'name' => name,
              'type' => "Microsoft.Network/dnszones/#{record_type}",
              'etag' => '7f159cb1-653d-4920-bc03-153c700412a2',
              'location' => 'global',
              'tags' => {},
              'properties' =>
                {
                  'metadata' => {},
                  'fqdn' => "#{name}.#{zone_name}.",
                  'TTL' => ttl,
                  'ARecords' =>
                    [
                      {
                        'ipv4Address' => records[0]
                      }
                    ]
                }
            }
          elsif record_type == 'CNAME'
            {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/dnszones/#{zone_name}/#{record_type}/#{name}",
              'name' => name,
              'type' => "Microsoft.Network/dnszones/#{record_type}",
              'etag' => 'cc5ceb6e-16ad-4a5f-bbd7-9bc31c12d0cf',
              'location' => 'global',
              'tags' => {},
              'properties' =>
                {
                  'metadata' => {},
                  'fqdn' => "#{name}.#{zone_name}.",
                  'TTL' => ttl,
                  'CNAMERecord' =>
                    {
                      'cname' => records[0]
                    }
                }
            }
          end
        end
      end
    end
  end
end
