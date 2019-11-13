module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_virtual_machines(resource_group)
          msg = "Listing Virtual Machines in Resource Group '#{resource_group}'"
          Fog::Logger.debug msg
          begin
            virtual_machines = @compute_mgmt_client.virtual_machines.list_as_lazy(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "listing Virtual Machines in Resource Group '#{resource_group}' successful"
          virtual_machines.value
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_virtual_machines(*)
          vms = {
            'value' => [
              {
                'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Compute/virtualMachines/fog-test-server',
                'name' => 'fog-test-server',
                'location' => 'West US',
                'properties' => {
                  'hardwareProfile' => {
                    'vmSize' => 'Basic_A0'
                  },
                  'storageProfile' => {
                    'imageReference' => {
                      'publisher' => 'Canonical',
                      'offer' => 'UbuntuServer',
                      'sku' => '14.04.2-LTS',
                      'version' => 'latest'
                    },
                    'osDisk' => {
                      'name' => 'fog-test-server_os_disk',
                      'vhd' => {
                        'uri' => 'http://storageAccount.blob.core.windows.net/vhds/fog-test-server_os_disk.vhd'
                      }
                    }
                  },
                  'osProfile' => {
                    'computerName' => 'fog-test-server',
                    'adminUsername' => 'shaffan',
                    'linuxConfiguration' => {
                      'disablePasswordAuthentication' => false
                    }
                  },
                  'networkProfile' => {
                    'networkInterfaces' => [
                      {
                        'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/networkInterfaces/fog-test-vnet'
                      }
                    ]
                  }
                }
              }
            ]
          }
          vm_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualMachineListResult.mapper
          @compute_mgmt_client.deserialize(vm_mapper, vms, 'result.body').value
        end
      end
    end
  end
end
