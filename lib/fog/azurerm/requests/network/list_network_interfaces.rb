module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_network_interfaces(resource_group)
          msg = "Getting list of NetworkInterfaces from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            network_interfaces = @network_client.network_interfaces.list_as_lazy(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          network_interfaces.value
        end
      end

      # Mock class for Network Request
      class Mock
        def list_network_interfaces(resource_group)
          nic =
            {
              'value' =>
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
                              'name' => 'ipconfig1'
                            }
                          ],
                        'dnsSettings' =>
                          {
                            'dnsServers' => [],
                            'appliedDnsServers' => []
                          },
                        'enableIPForwarding' => false,
                        'resourceGuid' => '51e01337-fb15-4b04-b9de-e91537c764fd',
                        'provisioningState' => 'Succeeded'
                      }
                  }
                ]
            }
          network_interface_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkInterfaceListResult.mapper
          @network_client.deserialize(network_interface_mapper, nic, 'result.body').value
        end
      end
    end
  end
end
