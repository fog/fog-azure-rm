module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def get_records_from_record_set(resource_group, name, zone_name, record_type)
          msg = "Getting all records from RecordSet #{name} of type '#{record_type}' in zone #{zone_name}"
          Fog::Logger.debug msg
          begin
            record_set = @dns_client.record_sets.get(resource_group, zone_name, name, record_type)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          case record_type
            when 'A'
              record_set.arecords
            when 'CNAME'
              record_set.cname_record
          end
        end
      end

      # Mock class for DNS Request
      class Mock
        def get_records_from_record_set(*)
          %w('1.2.3.4', '1.2.3.5', '1.2.3.6')
        end
      end
    end
  end
end
