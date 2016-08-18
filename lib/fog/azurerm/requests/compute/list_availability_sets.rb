module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_availability_sets(resource_group)
          begin
            Fog::Logger.debug "Listing Availability Sets in Resource Group: #{resource_group}"
            avail_sets = @compute_mgmt_client.availability_sets.list(resource_group)
            result_mapper = Azure::ARM::Compute::Models::AvailabilitySetListResult.mapper
            @compute_mgmt_client.serialize(result_mapper, avail_sets, 'parameters')['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing availability sets in Resource Group #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_availability_sets(resource_group)
          [
            {
              'id' => "/subscriptions/{subscription-id}/resourceGroups/#{resource_group}/providers/Microsoft.Compute/availabilitySets/test_availability_set",
              'name' => 'test_availability_set',
              'type' => 'Microsoft.Compute/availabilitySets',
              'location' => 'westus',
              'tags' =>  {},
              'properties' =>
              {
                'platformUpdateDomainCount' => 5,
                'platformFaultDomainCount' => 3,
                'virtualMachines' => []
              }
            }
          ]
        end
      end
    end
  end
end
