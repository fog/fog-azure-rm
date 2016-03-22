module Fog
  module DNS
    class AzureRM
      class Real
        def list_zones
          zone_hash_array = []
          @resources.resource_groups.each do |rg|
            @zone.list_zones(rg.name).each do |zone_hash|
              zone_hash['resource_group'] = rg.name              
              zone_hash_array << zone_hash
            end
          end
          zone_hash_array
        end
      end

      class Mock
        def list_zones
        end
      end
    end
  end
end