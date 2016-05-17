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

        def get(identity, resource_group)
          all.find { |f| f.name == identity && f.resource_group == resource_group }
        end

        def check_for_zone(resource_group, name)
          service.check_for_zone(resource_group, name)
        end
      end
    end
  end
end
