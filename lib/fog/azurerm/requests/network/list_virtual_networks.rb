module Fog
  module Network
    class AzureRM
      class Real
        def list_virtual_networks(resource_group)
          begin
            response = @network_client.virtual_networks.list(resource_group)
            result = response.value!
            Azure::ARM::Network::Models::VirtualNetworkListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Virtual Networks. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      class Mock
        def list_virtual_networks(_resource_group)
          [
            {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{_resource_group}/providers/Microsoft.Network/virtualNetworks/testVnet",
              'name' => 'testVnet',
              'type' => 'Microsoft.Network/virtualNetworks',
              'location' => 'westus',
              'properties' =>
                {
                  'addressSpace' =>
                    {
                      'addressPrefixes' =>
                        [
                          "10.1.0.0/16",
                          "10.2.0.0/16"
                        ]
                    },
                  'subnets' =>
                    [
                      {
                        'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{_resource_group}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/subnet_0_testVnet",
                        'properties' =>
                          {
                            'addressPrefix' => '10.1.0.0/24',
                            'provisioningState' => 'Succeeded'
                          },
                        'name' => 'subnet_0_testVnet',
                        'etag' => "W/\"8d90d220-7911-4376-bba0-88b0473e1d16\""
                      },
                      {
                        'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{_resource_group}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/fog-test-subnet",
                        'properties' =>
                          {
                            'addressPrefix' => '10.2.0.0/16',
                            'ipConfigurations' =>
                              [
                                {
                                  'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{_resource_group}/providers/Microsoft.Network/networkInterfaces/test-NIC/ipConfigurations/ipconfig1"
                                }
                              ],
                            'provisioningState' => 'Succeeded'
                          },
                        'name' => 'fog-test-subnet',
                        'etag' => "W/\"8d90d220-7911-4376-bba0-88b0473e1d16\""
                      }
                    ],
                  'resourceGuid' => 'c573f8e2-d916-493f-8b25-a681c31269ef',
                  'provisioningState' => 'Succeeded'
                },
              'etag' => "W/\"8d90d220-7911-4376-bba0-88b0473e1d16\""
            }
          ]
        end
      end
    end
  end
end
