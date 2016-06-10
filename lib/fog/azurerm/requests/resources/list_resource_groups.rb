module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_resource_groups
          begin
            promise = @rmc.resource_groups.list
            result = promise.value!
            result.body.next_link = ''
            Azure::ARM::Resources::Models::ResourceGroupListResult.serialize_object(result.body)['value']
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Resource Groups. #{e.body['error']['message']}"
            raise msg
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
