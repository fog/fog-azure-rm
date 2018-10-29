
module ApiStub
  module Models
    module Compute
      class VirtualMachineSize
        def self.virtual_machine_sizes(sdk_compute_client)
          virtual_machine_sizes = {
            'value' => [
              {
                'max_data_disk_count' => 1,
                'memory_in_mb' => 768,
                'name' => 'Standard_A0',
                'number_of_cores' => 1,
                'os_disk_size_in_mb' => 1_047_552,
                'resource_disk_size_in_mb' => 20_480
              },
              {
                'max_data_disk_count' => 2,
                'memory_in_mb' => 1_792,
                'name' => 'Standard_A1',
                'number_of_cores' => 1,
                'os_disk_size_in_mb' => 1_047_552,
                'resource_disk_size_in_mb' => 71_680
              },
              {
                'max_data_disk_count' => 4,
                'memory_in_mb' => 3_584,
                'name' => 'Standard_A2',
                'number_of_cores' => 2,
                'os_disk_size_in_mb' => 1_047_552,
                'resource_disk_size_in_mb' => 138_240
              },
              {
                'max_data_disk_count' => 1,
                'memory_in_mb' => 768,
                'name' => 'Basic_A0',
                'number_of_cores' => 1,
                'os_disk_size_in_mb' => 1_047_552,
                'resource_disk_size_in_mb' => 20_480
              }
            ]
          }
          virtual_machine_size_mapper = Azure::ARM::Compute::Models::VirtualMachineSizeListResult.mapper
          sdk_compute_client.deserialize(virtual_machine_size_mapper, virtual_machine_sizes, 'result.body').value
        end
      end
    end
  end
end
