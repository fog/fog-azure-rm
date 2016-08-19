module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def get_availability_set(resource_group, name)
          begin
            @compute_mgmt_client.availability_sets.get(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def get_availability_set(resource_group, name)
          {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Compute/virtualMachines/#{name}",
              'name' => name,
              'type' => 'Microsoft.Compute/virtualMachines',
              'location' => 'westus',
              '@platform_update_domain_count' => 2,
              '@platform_fault_domain_count' => 2,
              '@virtual_machines' => []
          }
        end
      end
    end
  end
end
