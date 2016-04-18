module Fog
  module Resources
    class AzureRM
      class Real
        def list_resource_groups
          begin
            promise = @rmc.resource_groups.list
            response = promise.value!
            response.body.value
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Resource Groups. #{e.body['error']['message']}"
            raise msg
          end
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
