module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_network_interfaces(resource_group)
          Fog::Logger.debug "Getting list of NetworkInterfaces from Resource Group #{resource_group}."
          begin
            promise = @network_client.network_interfaces.list(resource_group)
            result = promise.value!
            Azure::ARM::Network::Models::NetworkInterfaceListResult.serialize_object(result.body)['value']
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Network Interfaces from Resource Group '#{resource_group}'. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_network_interfaces(resource_group)
          [
            {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/test-NIC",
              'name' => 'test-NIC',
              'type' => 'Microsoft.Network/networkInterfaces',
              'location' => 'westus',
              'properties' =>
                {
                  'ipConfigurations' =>
                    [
                      {
                        'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/test-NIC/ipConfigurations/ipconfig1",
                        'properties' =>
                          {
                            'privateIPAddress' => '10.2.0.4',
                            'privateIPAllocationMethod' => 'Dynamic',
                            'subnet' =>
                               {
                                 'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/fog-test-subnet"
                               },
                            'provisioningState' => 'Succeeded'
                          },
                        'name' => 'ipconfig1',
                        'etag' => "W/\"b5dd021a-fcce-43b2-9e07-01407a3a6a98\""
                      }
                    ],
                  'dnsSettings' =>
                    {
                      'dnsServers' => [],
                      'appliedDnsServers' => []
                    },
                  'enableIPForwarding' =>false,
                  'resourceGuid' => '51e01337-fb15-4b04-b9de-e91537c764fd',
                  'provisioningState' => 'Succeeded'
                },
              'etag' =>"W/\"b5dd021a-fcce-43b2-9e07-01407a3a6a98\""
            }
          ]
        end
      end
    end
  end
end
