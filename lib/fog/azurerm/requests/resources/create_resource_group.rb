module Fog
  module Resources
    class AzureRM
      class Real
        def create_resource_group(name, parameters)
          @rmc.resource_groups.create_or_update(name, parameters)
        end
      end

      class Mock
        def create_resource_group(name, parameters)

        end
      end
    end
  end
end