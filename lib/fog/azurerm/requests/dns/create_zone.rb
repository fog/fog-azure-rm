module Fog
  module DNS
    class AzureRM
      class Real
        def create_zone(dns_resource_group, zone_name)
          @zone.create(dns_resource_group, zone_name)
        end
      end

      class Mock
        def create_zone(dns_resource_group, zone_name)

        end
      end
    end
  end
end
