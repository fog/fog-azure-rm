module Fog
  module Network
    class AzureRM
      # Real class for Network Interface Request
      class Real
        def get_network_interface(resource_group_name, nic_name)
          msg = "Getting Network Interface#{nic_name} from Resource Group #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            @network_client.network_interfaces.get(resource_group_name, nic_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end

      # Mock class for Network Interface Request
      class Mock
        def get_network_interface(resource_group_name, nic_name)
          nic = {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkInterfaces/#{nic_name}",
            'name' => nic_name,
            'type' => 'Microsoft.Network/networkInterfaces',
            'location' => 'westus',
            'properties' =>
              {
                'ipConfigurations' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkInterfaces/test-NIC/ipConfigurations/ipconfig1",
                      'properties' =>
                        {
                          'privateIPAddress' => '10.2.0.4',
                          'privateIPAllocationMethod' => 'Dynamic',
                          'subnet' =>
                            {
                              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/fog-test-subnet"
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
          network_interface_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkInterface.mapper
          @network_client.deserialize(network_interface_mapper, nic, 'result.body')
        end
      end
    end
  end
end
