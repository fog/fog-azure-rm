module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_subnets(resource_group, virtual_network_name)
          msg = "Listing Subnets int Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            subnets = @network_client.subnets.list_as_lazy(resource_group, virtual_network_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          subnets.value
        end
      end

      # Mock class for Network Request
      class Mock
        def list_subnets(resource_group, virtual_network_name)
          subnet = {
            'value' => [
              {
                'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/virtualNetworks/#{virtual_network_name}/subnets/subnet_0_testVnet",
                'properties' =>
                  {
                    'addressPrefix' => '10.1.0.0/24',
                    'provisioningState' => 'Succeeded'
                  },
                'name' => 'subnet_0_testVnet'
              },
              {
                'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/virtualNetworks/#{virtual_network_name}/subnets/fog-test-subnet",
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
            ]
          }
          subnet_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::SubnetListResult.mapper
          @network_client.deserialize(subnet_mapper, subnet, 'result.body').value
        end
      end
    end
  end
end
