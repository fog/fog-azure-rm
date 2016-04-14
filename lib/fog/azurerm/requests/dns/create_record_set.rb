module Fog
  module DNS
    class AzureRM
      class Real
        def create_record_set(dns_resource_group, zone_name, record_set_name, records, record_type, ttl)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{record_set_name}?api-version=2015-05-04-preview"
          Fog::Logger.debug "Creating/Updating RecordSet #{record_set_name} of type '#{record_type}' in zone #{zone_name}"

          case record_type
            when 'A'
              a_type_records_array = Array.new
              records.each do |ip|
                a_type_records_array.push({'ipv4Address' => ip})
              end
              body = {
                  :location => 'global',
                  :tags => '',
                  :properties => {
                      :TTL => ttl,
                      :ARecords => a_type_records_array
                  }
              }
            when 'CNAME'
              body = {
                  :location => 'global',
                  :tags => '',
                  :properties => {
                      :TTL => ttl,
                      :CNAMERecord => {
                          'cname' => records.first # because cname only has 1 value and we know the object is an array passed in.
                      }
                  }
              }
          end

          token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
          begin
            dns_response = RestClient.put(
                resource_url,
                body.to_json,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token
            )
            Fog::Logger.debug "RecordSet #{record_set_name} Created/Updated Successfully!"
          rescue Exception => e
            Fog::Logger.warning "Exception setting #{record_type} records for the record set: #{record_set_name}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            fail msg
          end
        end
      end

      class Mock
        def create_record_set(dns_resource_group, zone_name, record_set_name, records, record_type, ttl)

        end
      end
    end
  end
end