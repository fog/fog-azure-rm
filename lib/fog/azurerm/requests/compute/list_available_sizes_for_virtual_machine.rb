module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_available_sizes_for_virtual_machine(resource_group, name)
          begin
            response = @compute_mgmt_client.virtual_machines.list_available_sizes(resource_group, name)
            result = response.value!
            Azure::ARM::Compute::Models::VirtualMachineSizeListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error listing Sizes for Virtual Machine #{name} in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_available_sizes_for_virtual_machine(resource_group, name)
          [
            {
              "name"=>"Standard_A0",
              "numberOfCores"=>1,
              "osDiskSizeInMB"=>1047552,
              "resourceDiskSizeInMB"=>20480,
              "memoryInMB"=>768,
              "maxDataDiskCount"=>1
            },
            {
              "name"=>"Standard_A1",
              "numberOfCores"=>1,
              "osDiskSizeInMB"=>1047552,
              "resourceDiskSizeInMB"=>71680,
              "memoryInMB"=>1792,
              "maxDataDiskCount"=>2
            },
            {
              "name"=>"Standard_A2",
              "numberOfCores"=>2,
              "osDiskSizeInMB"=>1047552,
              "resourceDiskSizeInMB"=>138240,
              "memoryInMB"=>3584,
              "maxDataDiskCount"=>4
            }
        ]
        end
      end
    end
  end
end
