INSTANCE_VIEW = 'instanceView'.freeze

module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def get_virtual_machine(resource_group, name, async)
          msg = "Getting Virtual Machine #{name} from Resource Group '#{resource_group}'"
          Fog::Logger.debug msg
          begin
            if async
              response = @compute_mgmt_client.virtual_machines.get_async(resource_group, name, expand: INSTANCE_VIEW)
            else
              response = @compute_mgmt_client.virtual_machines.get(resource_group, name, expand: INSTANCE_VIEW)
            end
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Getting Virtual Machine #{name} from Resource Group '#{resource_group}' successful" unless async
          response
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def get_virtual_machine(*)
          vm = {
            'location' => 'westus',
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
                          'uri' => 'http://fogtestsafirst.blob.core.windows.net/vhds/fog-test-server_os_disk.vhd'
                        },
                      'createOption' => 'FromImage',
                      'osType' => 'Linux',
                      'caching' => 'ReadWrite'
                    },
                  'dataDisks' => []
                },
              'osProfile' =>
                {
                  'computerName' => 'fog',
                  'adminUsername' => 'testfog',
                  'linuxConfiguration' =>
                    {
                      'disablePasswordAuthentication' => false
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
