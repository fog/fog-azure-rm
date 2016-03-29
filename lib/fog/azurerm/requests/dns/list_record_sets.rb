module Fog
  module DNS
    class AzureRM
      class Real
        def list_record_sets(dns_resource_group, zone_name)
          @record_set.list_record_sets(dns_resource_group, zone_name)
        end
      end

      class Mock
        def list_record_sets(dns_resource_group, zone_name)

        end
      end
    end
  end
end