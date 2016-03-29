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
        def list_resource_groups
          resource_group = ::Azure::ARM::Resources::Models::ResourceGroup.new
          resource_group.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-resource-group'
          resource_group.name = 'fog-test-resource-group'
          resource_group.location = 'West US'
          [resource_group]
        end
      end
    end
  end
end
