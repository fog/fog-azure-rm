module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_availability_sets(resource_group)
          msg = "Listing Availability Sets in Resource Group: #{resource_group}"
          Fog::Logger.debug msg
          begin
            avail_sets = @compute_mgmt_client.availability_sets.list(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Listing Availability Sets in Resource Group: #{resource_group} successful."
          avail_sets.value
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
