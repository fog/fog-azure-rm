module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_resource_groups
          Fog::Logger.debug 'Listing Resource Groups'
          begin
            resource_groups = @rmc.resource_groups.list_as_lazy
            resource_groups.next_link = ''
            result_mapper = Azure::ARM::Resources::Models::ResourceGroupListResult.mapper
            @rmc.serialize(result_mapper, resource_groups, 'parameters')['value']
          rescue  MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def list_resource_groups
          [
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
          ]
        end
      end
    end
  end
end
