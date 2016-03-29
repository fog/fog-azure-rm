module Fog
  module DNS
    class AzureRM
      class Real
        def delete_record_set(record_set_name, dns_resource_group, zone_name, record_type)
          @record_set.remove_record_set(record_set_name, dns_resource_group, zone_name, record_type)
        end
      end

      class Mock
        def delete_record_set(record_set_name, dns_resource_group, zone_name, record_type)

        end
      end
    end
  end
end