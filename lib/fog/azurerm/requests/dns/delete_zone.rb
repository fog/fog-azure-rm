module Fog
  module DNS
    class AzureRM
      class Real
        def delete_zone(zone_name, dns_resource_group)
          @zone.delete(dns_resource_group, zone_name)
        end
      end

      class Mock
        def delete_zone(zone_name, dns_resource_group)

        end
      end
    end
  end
end