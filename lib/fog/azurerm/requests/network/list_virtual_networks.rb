module Fog
  module Network
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_virtual_networks(resource_group)
          msg = "Listing Virtual Networks in Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            virtual_networks = @network_client.virtual_networks.list_as_lazy(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          virtual_networks.value
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def list_virtual_networks(resource_group)
          virtual_network = {
            'value' => [
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
                          %w(10.1.0.0/16 10.2.0.0/16)
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
          }
          vnet_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetworkListResult.mapper
          @network_client.deserialize(vnet_mapper, virtual_network, 'result.body').value
        end
      end
    end
  end
end
