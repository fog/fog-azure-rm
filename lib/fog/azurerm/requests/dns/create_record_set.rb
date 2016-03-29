module Fog
  module DNS
    class AzureRM
      class Real
        def create_record_set(dns_resource_group, zone_name, record_set_name, records, record_type, ttl)
          @record_set.set_records_on_record_set(dns_resource_group, zone_name, record_set_name, records, record_type, ttl)
        end
      end

      class Mock
        def create_record_set(dns_resource_group, zone_name, record_set_name, records, record_type, ttl)

        end
      end
    end
  end
end