require 'fog/core/collection'
require 'fog/azurerm/models/dns/zone'

module Fog
  module DNS
    class AzureRM
      class Zones < Fog::Collection
        model Fog::DNS::AzureRM::Zone

        def all
          zones = []
          service.list_zones.each do |z|
            hash = {}
            z.each do |k, v|
              hash[k] = v
            end
            zones << hash
          end
          load(zones)
        end

        def get(identity, resource_group)
          all.find { |f| f.name == identity && f.resource_group == resource_group }
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
