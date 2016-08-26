module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_available_sizes_for_virtual_machine(resource_group, name)
          msg = "Listing sizes for Virtual Machine #{name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            vm_sizes = @compute_mgmt_client.virtual_machines.list_available_sizes(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully listed sizes for Virtual Machine #{name} in Resource Group #{resource_group}"
          vm_sizes.value
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_available_sizes_for_virtual_machine(*)
          vm_sizes =
            {
              'value' => [
                {
                  'name' => 'Standard_A0',
                  'numberOfCores' => 1,
                  'osDiskSizeInMB' => 1_047_552,
                  'resourceDiskSizeInMB' => 20_480,
                  'memoryInMB' => 768,
                  'maxDataDiskCount' => 1
                },
                {
                  'name' => 'Standard_A1',
                  'numberOfCores' => 1,
                  'osDiskSizeInMB' => 1_047_552,
                  'resourceDiskSizeInMB' => 71_680,
                  'memoryInMB' => 1792,
                  'maxDataDiskCount' => 2
                },
                {
                  'name' => 'Standard_A2',
                  'numberOfCores' => 2,
                  'osDiskSizeInMB' => 1_047_552,
                  'resourceDiskSizeInMB' => 138_240,
                  'memoryInMB' => 3584,
                  'maxDataDiskCount' => 4
                }
              ]
            }
          vm_mapper = Azure::ARM::Compute::Models::VirtualMachineSizeListResult.mapper
          @compute_mgmt_client.deserialize(vm_mapper, vm_sizes, 'result.body').value
        end
      end
    end
  end
end
