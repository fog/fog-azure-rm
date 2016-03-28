module Fog
  module Resources
    class AzureRM
      class Real
        def delete_resource_group(name)
          @rmc.resource_groups.delete(name)
        end
      end

      class Mock
        def delete_resource_group(name)
        end
      end
    end
  end
end
