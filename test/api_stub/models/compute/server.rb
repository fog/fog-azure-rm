module ApiStub
  module Models
    module Compute
      # Mock class for Server Set Model
      class Server
        def self.create_virtual_machine_response
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
                    'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/networkInterfaces/fogtestnetworkinterface'
                  }
                ]
              }
            }
          }
        end
      end
    end
  end
end
