module Fog
  module Network
    class AzureRM
      # Real class for Network Interface Request
      class Real
        def get_network_interface(resource_group_name, nic_name)
          Fog::Logger.debug "Getting Network Interface#{nic_name} from Resource Group #{resource_group_name}."
          begin
            promise = @network_client.network_interfaces.get(resource_group_name, nic_name)
            result = promise.value!
            Azure::ARM::Network::Models::NetworkInterface.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception getting Network Interface #{nic_name} from Resource Group '#{resource_group_name}'. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Network Interface Request
      class Mock
        def get_network_interface(resource_group_name, nic_name)
          {
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
        end
      end
    end
  end
end
