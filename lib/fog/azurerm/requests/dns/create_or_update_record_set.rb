module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def create_or_update_record_set(record_set_params, type)
          msg = "Creating/updating Recordset #{record_set_params[:name]} in Resource Group: #{record_set_params[:resource_group]}."
          Fog::Logger.debug msg
          recordset_object = get_record_set_object(record_set_params, type)
          begin
            record_set = @dns_client.record_sets.create_or_update(record_set_params[:resource_group], record_set_params[:zone_name], record_set_params[:name], type, recordset_object)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Record Set #{record_set_params[:name]} created/updated successfully."
          record_set
        end

        private

        def get_record_set_object(record_set_params, type)
          record_set = Azure::ARM::Dns::Models::RecordSet.new
          record_set.name = record_set_params[:name]
          record_set.type = type
          record_set.ttl = record_set_params[:ttl]
          record_set.etag = record_set_params[:etag]
          case type
          when 'A'
            a_type_records_array = []
            record_set_params[:records].each do |ip|
              a_record = Azure::ARM::Dns::Models::ARecord.new
              a_record.ipv4address = ip
              a_type_records_array.push(a_record)
            end
            record_set.arecords = a_type_records_array
          when 'CNAME'
            record_set.cname_record = record_set_params[:records].first # because cname only has 1 value and we know the object is an array passed in.
          end

          record_set
        end
      end

      # Mock class for DNS Request
      class Mock
        def create_or_update_record_set(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.Network/dnszones/zone_name/record_type/name',
            'name' => 'name',
            'type' => 'Microsoft.Network/dnszones/record_type',
            'etag' => '7f159cb1-653d-4920-bc03-153c700412a2',
            'location' => 'global',
            'tags' => {},
            'properties' =>
              {
                'metadata' => {},
                'fqdn' => 'name.zone_name',
                'TTL' => 10,
                'ARecords' =>
                  [
                    {
                      'ipv4Address' => '10.1.2.0'
                    }
                  ]
              }
          }
        end
      end
    end
  end
end
