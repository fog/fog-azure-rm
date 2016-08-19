module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_subnets(resource_group, virtual_network_name)
          begin
            subnets = @network_client.subnets.list_as_lazy(resource_group, virtual_network_name)
            subnets.next_link = '' if subnets.next_link.nil?
            subnets.value
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_subnets(resource_group, virtual_network_name)
          [
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
        end
      end
    end
  end
end
