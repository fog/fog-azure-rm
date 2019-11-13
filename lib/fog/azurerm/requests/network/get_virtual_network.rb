module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def get_virtual_network(resource_group_name, virtual_network_name)
          get_vnet(resource_group_name, virtual_network_name)
        end

        private

        def get_vnet(resource_group_name, virtual_network_name)
          msg = "Getting Virtual Network: #{virtual_network_name}."
          Fog::Logger.debug msg
          begin
            virtual_network = @network_client.virtual_networks.get(resource_group_name, virtual_network_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Network #{virtual_network_name} retrieved successfully."
          virtual_network
        end
      end

      # Mock class for Network Request
      class Mock
        def get_virtual_network(*)
          virtual_network = {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet',
            'name' => 'fog-vnet',
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
                      'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet',
                      'properties' =>
                        {
                          'addressPrefix' => '10.1.0.0/24',
                          'provisioningState' => 'Succeeded'
                        },
                      'name' => 'fog-subnet'
                    }
                  ],
                'resourceGuid' => 'c573f8e2-d916-493f-8b25-a681c31269ef',
                'provisioningState' => 'Succeeded'
              }
          }
          vnet_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetwork.mapper
          @network_client.deserialize(vnet_mapper, virtual_network, 'result.body')
        end
      end
    end
  end
end
