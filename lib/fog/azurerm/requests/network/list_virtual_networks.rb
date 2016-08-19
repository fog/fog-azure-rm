module Fog
  module Network
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_virtual_networks(resource_group)
          begin
            virtual_networks = @network_client.virtual_networks.list_as_lazy(resource_group)
            virtual_networks.next_link = '' if virtual_networks.next_link.nil?
            virtual_networks.value
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def list_virtual_networks(resource_group)
          [
            {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/virtualNetworks/testVnet",
              'name' => 'testVnet',
              'type' => 'Microsoft.Network/virtualNetworks',
              'location' => 'westus',
              'properties' =>
                {
                  'addressSpace' =>
                    {
                      'addressPrefixes' =>
                        [
                          '10.1.0.0/16',
                          '10.2.0.0/16'
                        ]
                    },
                  'subnets' =>
                    [
                      {
                        'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/subnet_0_testVnet",
                        'properties' =>
                          {
                            'addressPrefix' => '10.1.0.0/24',
                            'provisioningState' => 'Succeeded'
                          },
                        'name' => 'subnet_0_testVnet'
                      },
                      {
                        'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/fog-test-subnet",
                        'properties' =>
                          {
                            'addressPrefix' => '10.2.0.0/16',
                            'ipConfigurations' =>
                              [
                                {
                                  'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/test-NIC/ipConfigurations/ipconfig1"
                                }
                              ],
                            'provisioningState' => 'Succeeded'
                          },
                        'name' => 'fog-test-subnet'
                      }
                    ],
                  'resourceGuid' => 'c573f8e2-d916-493f-8b25-a681c31269ef',
                  'provisioningState' => 'Succeeded'
                }
            }
          ]
        end
      end
    end
  end
end
