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

        def self.delete_virtual_machine_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end

        def self.list_available_sizes_for_virtual_machine_response
          body = '{
            "value": [
              {
                "name": "Standard_A0",
                "numberOfCores": 1,
                "osDiskSizeInMB": 130048,
                "resourceDiskSizeInMB": 20480,
                "memoryInMB": 768,
                "maxDataDiskCount": 1
              }
            ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Compute::Models::VirtualMachineSizeListResult.deserialize_object(JSON.load(body))
          result.body.value
        end

        def self.virtual_machine_response
          Azure::ARM::Compute::Models::VirtualMachine.deserialize_object(create_virtual_machine_response)
        end
      end
    end
  end
end
