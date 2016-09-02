module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_resource_group(resource_group_name)
          msg = "Getting Resource Group #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            resource_group = @rmc.resource_groups.get(resource_group_name)
            Fog::Logger.debug "Getting Resource Group #{resource_group_name} successfully"
            resource_group
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_resource_group(*)
          resource_group =
            {
              'location' => 'westus',
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/Fog_test_rg',
              'name' => 'Fog_test_rg',
              'properties' =>
                {
                  'provisioningState' => 'Succeeded'
                }
            },
            {
              'location' => 'westus',
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/Fog_test_rg1',
              'name' => 'Fog_test_rg1',
              'properties' =>
                {
                  'provisioningState' => 'Succeeded'
                }
            }
          result_mapper = Azure::ARM::Resources::Models::ResourceGroup.mapper
          @rmc.deserialize(result_mapper, resource_group, 'result.body')
        end
      end
    end
  end
end
