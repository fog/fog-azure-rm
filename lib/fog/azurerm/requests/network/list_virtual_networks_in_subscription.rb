module Fog
  module Network
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_virtual_networks_in_subscription
          msg = 'Listing Virtual Networks in a subscription'
          Fog::Logger.debug msg
          begin
            virtual_networks = @network_client.virtual_networks.list_all
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          virtual_networks
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def list_virtual_networks_in_subscription
          virtual_network = {
            'value' => [
              {
                'id' => '/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Network/virtualNetworks/testVnet',
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
                          'id' => '/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/subnet_0_testVnet',
                          'properties' =>
                            {
                              'addressPrefix' => '10.1.0.0/24',
                              'provisioningState' => 'Succeeded'
                            },
                          'name' => 'subnet_0_testVnet'
                        },
                        {
                          'id' => '/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/fog-test-subnet',
                          'properties' =>
                            {
                              'addressPrefix' => '10.2.0.0/16',
                              'ipConfigurations' =>
                                [
                                  {
                                    'id' => '/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Network/networkInterfaces/test-NIC/ipConfigurations/ipconfig1'
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
          @network_client.deserialize(vnet_mapper, virtual_network, 'result.body')
        end
      end
    end
  end
end
