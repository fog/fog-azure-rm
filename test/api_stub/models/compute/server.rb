module ApiStub
  module Models
    module Compute
      # Mock class for Server Model
      class Server
        def self.create_linux_virtual_machine_response
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
                },
                'dataDisks' => [
                  {
                    'name' => 'disk1',
                    'diskSizeGB' => '10',
                    'lun' => 0,
                    'vhd' => {
                      'uri' => 'http://mystorage1.blob.core.windows.net/vhds/disk1.vhd'
                    }
                  }
                ]
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

        def self.create_windows_virtual_machine_response
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
                  'publisher' => 'MicrosoftWindowsServerEssentials',
                  'offer' => 'WindowsServerEssentials',
                  'sku' => 'WindowsServerEssentials',
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
                'windowsConfiguration' => {
                  'provisionVMAgent' => true,
                  'winRM' => {
                    'listeners' => [{
                      'protocol' => 'https',
                      'certificateUrl' => 'certificateUrl'
                    }]
                  },
                  'additionalUnattendContent' => {
                    'pass' => 'oobesystem',
                    'component' => 'Microsoft-Windows-Shell-Setup',
                    'settingName' => 'FirstLogonCommands|AutoLogon',
                    'content' => '<XML unattend content>'
                  },
                  'enableAutomaticUpdates' => true
                },
                'secrets' => []
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

        def self.attach_data_disk_response
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
                },
                'dataDisks' => [
                  {
                    'name' => 'disk1',
                    'diskSizeGB' => '10',
                    'lun' => 0,
                    'vhd' => {
                      'uri' => 'http://mystorage1.blob.core.windows.net/vhds/disk1.vhd'
                    }
                  },
                  {
                    'name' => 'disk2',
                    'diskSizeGB' => '10',
                    'lun' => 0,
                    'vhd' => {
                      'uri' => 'http://mystorage1.blob.core.windows.net/vhds/disk2.vhd'
                    }
                  }
                ]
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
