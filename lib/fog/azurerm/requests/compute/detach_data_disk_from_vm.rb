module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def detach_data_disk_from_vm(resource_group, vm_name, disk_name, async)
          msg = "Detaching Data Disk #{disk_name} from Virtual Machine #{vm_name} in Resource Group #{resource_group}."
          Fog::Logger.debug msg
          vm = get_virtual_machine_instance(resource_group, vm_name)
          vm.storage_profile.data_disks.each_with_index do |disk, index|
            if disk.name == disk_name
              vm.storage_profile.data_disks.delete_at(index)
            end
          end
          begin
            if async
              response = @compute_mgmt_client.virtual_machines.create_or_update_async(resource_group, vm_name, vm)
            else
              virtual_machine = @compute_mgmt_client.virtual_machines.create_or_update(resource_group, vm_name, vm)
            end
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          if async
            response
          else
            Fog::Logger.debug "Data Disk #{disk_name} detached from Virtual Machine #{vm_name} successfully."
            virtual_machine
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def detach_data_disk_from_vm(*)
          vm = {
            'location' => 'West US',
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Compute/virtualMachines/fog-test-server',
            'name' => 'fog-test-server',
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
                        'name' => 'fog-test-server_os_disk',
                        'vhd' =>
                          {
                            'uri' => 'http://mystorage1.blob.core.windows.net/vhds/fog-test-server_os_disk.vhd'
                          },
                        'createOption' => 'FromImage',
                        'osType' => 'Linux',
                        'caching' => 'ReadWrite'
                      },
                    'dataDisks' => [{
                      'lun' => 0,
                      'name' => 'fog-test-server_data_disk',
                      'vhd_uri' => 'https://confizrg7443.blob.core.windows.net/vhds/fog-test-server_data_disk.vhd',
                      'create_option' => 'empty',
                      'disk_size_gb' => 1
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
                          'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/networkInterfaces/fog-test-vnet'
                        }
                      ]
                  },
                'provisioningState' => 'Succeeded'
              }
          }
          vm_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualMachine.mapper
          @compute_mgmt_client.deserialize(vm_mapper, vm, 'result.body')
        end
      end
    end
  end
end
