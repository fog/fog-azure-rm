module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def detach_data_disk_from_vm(resource_group, vm_name, disk_name)
          msg = "Detaching Data Disk #{disk_name} from Virtual Machine #{vm_name} in Resource Group #{resource_group}."
          Fog::Logger.debug msg
          vm = get_virtual_machine_instance(resource_group, vm_name, @compute_mgmt_client)
          vm.storage_profile.data_disks.each_with_index do |disk, index|
            if disk.name == disk_name
              vm.storage_profile.data_disks.delete_at(index)
            end
          end
          vm.resources = nil
          begin
            virtual_machine = @compute_mgmt_client.virtual_machines.create_or_update(resource_group, vm_name, vm)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Data Disk #{disk_name} detached from Virtual Machine #{vm_name} successfully."
          virtual_machine
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def detach_data_disk_from_vm(resource_group, vm_name, disk_name)
          vm = {
            'location' => 'West US',
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Compute/virtualMachines/#{name}",
            'name' => vm_name,
            'type' => 'Microsoft.Compute/virtualMachines',
            'properties' =>
              {
                'hardwareProfile' =>
                  {
                    'vmSize' => 'Basic_A0'
                  },
                'storageProfile' =>
                  {
                    'imageReference' =>
                      {
                        'publisher' => 'Canonical',
                        'offer' => 'UbuntuServer',
                        'sku' => '14.04.2-LTS',
                        'version' => 'latest'
                      },
                    'osDisk' =>
                      {
                        'name' => "#{vm_name}_os_disk",
                        'vhd' =>
                          {
                            'uri' => "http://#{storage_account_name}.blob.core.windows.net/vhds/#{vm_name}_os_disk.vhd"
                          },
                        'createOption' => 'FromImage',
                        'osType' => 'Linux',
                        'caching' => 'ReadWrite'
                      },
                    'dataDisks' => [{
                      'lun' => 0,
                      'name' => disk_name,
                      'vhd_uri' => "https://confizrg7443.blob.core.windows.net/vhds/#{disk_name}.vhd",
                      'create_option' => 'empty',
                      'disk_size_gb' => disk_size
                    }]
                  },
                'osProfile' =>
                  {
                    'computerName' => 'fog',
                    'adminUsername' => 'Fog=123',
                    'linuxConfiguration' =>
                      {
                        'disablePasswordAuthentication' => true
                      },
                    'secrets' => []
                  },
                'networkProfile' =>
                  {
                    'networkInterfaces' =>
                      [
                        {
                          'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/fog-test-vnet"
                        }
                      ]
                  },
                'provisioningState' => 'Succeeded'
              }
          }
          vm_mapper = Azure::ARM::Compute::Models::VirtualMachine.mapper
          @compute_mgmt_client.deserialize(vm_mapper, vm, 'result.body')
        end
      end
    end
  end
end
