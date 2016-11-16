module Fog
  module DNS
    class AzureRM
      # This class is giving implementation of
      # all/get for Zones.
      class Zones < Fog::Collection
        model Fog::DNS::AzureRM::Zone

        def all
          zones = []
          service.list_zones.each do |z|
            zones << Fog::DNS::AzureRM::Zone.parse(z)
          end
          load(zones)
        end

        def get(resource_group, name)
          zone = service.get_zone(resource_group, name)
          zone_fog = Fog::DNS::AzureRM::Zone.new(service: service)
          zone_fog.merge_attributes(Fog::DNS::AzureRM::Zone.parse(zone))
        end

        def check_for_zone(resource_group, name)
          service.check_for_zone(resource_group, name)
        end
      end
    end
  end
end
