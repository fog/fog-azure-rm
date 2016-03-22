module Fog
  module Resources
    class AzureRM
      class Real
        def list_resource_groups
          response = @rmc.resource_groups.list
          result = response.value!
          result.body.value
        end
      end

      class Mock
        def list_resource_groups(name, parameters)

        end
      end
    end
  end
end