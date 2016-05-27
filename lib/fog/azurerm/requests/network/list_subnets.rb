module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_subnets(resource_group, virtual_network_name)
          begin
            promise = @network_client.subnets.list(resource_group, virtual_network_name)
            result = promise.value!
            Azure::ARM::Network::Models::SubnetListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Subnets from Resource Group '#{resource_group}' in Virtal Network #{virtual_network_name}. #{e.body['error']['message']}."
            raise msg
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
              'name' => 'subnet_0_testVnet',
              'etag' => "W/\"8d90d220-7911-4376-bba0-88b0473e1d16\""
            },
            {
              'id' =>"/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/virtualNetworks/#{virtual_network_name}/subnets/fog-test-subnet",
              'properties' =>
                {
                  'addressPrefix' => '10.2.0.0/16',
                  'ipConfigurations' =>
                    [
                      {
                        'id' =>"/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/test-NIC/ipConfigurations/ipconfig1"
                      }
                    ],
                  'provisioningState' => 'Succeeded'
                },
              'name' => 'fog-test-subnet',
              'etag' => "W/\"8d90d220-7911-4376-bba0-88b0473e1d16\""
            }
          ]
        end
      end
    end
  end
end
