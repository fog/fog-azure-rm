module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_virtual_machines(resource_group)
          begin
            response = @compute_mgmt_client.virtual_machines.list(resource_group)
            result = response.value!
            Azure::ARM::Compute::Models::VirtualMachineListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error listing Virtual Machines in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_virtual_machines(resource_group)
          [
            {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Compute/virtualMachines/fog-test-server",
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
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/fogtestnetworkinterface"
                    }
                  ]
                }
              }
            }
          ]
        end
      end
    end
  end
end
