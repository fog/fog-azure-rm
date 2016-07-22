require 'fog/core/collection'
require 'fog/azurerm/models/dns/zone'

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

        def get(resource_group, identity)
          zone = service.get_zone(resource_group, identity)
          zone_obj = Fog::DNS::AzureRM::Zone.new
          zone_obj.instance_variable_set(:@service, service)
          zone_obj.merge_attributes(Fog::DNS::AzureRM::Zone.parse(zone))
        end

        def check_for_zone(resource_group, name)
          service.check_for_zone(resource_group, name)
        end
      end
    end
  end
end
