module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def add_subnets_in_virtual_network(resource_group_name, virtual_network_name, subnets)
          Fog::Logger.debug "Adding Subnets: in Virtual Network: #{virtual_network_name}"
          virtual_network = get_virtual_network_object_for_subnets!(resource_group_name, virtual_network_name, subnets)
          virtual_network = create_or_update_vnet(resource_group_name, virtual_network_name, virtual_network)
          Fog::Logger.debug 'Subnets added successfully.'
          virtual_network
        end

        private

        def get_virtual_network_object_for_subnets!(resource_group_name, virtual_network_name, subnets)
          virtual_network = get_vnet(resource_group_name, virtual_network_name)
          subnet_objects = define_subnet_objects(subnets)
          old_subnet_objects = virtual_network.subnets
          virtual_network.subnets = subnet_objects + old_subnet_objects
          virtual_network
        end
      end

      # Mock class for Network Request
      class Mock
        def add_subnets_in_virtual_network(*)
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
                      [
                        '10.1.0.0/16',
                        '10.2.0.0/16'
                      ]
                  },
                'dhcpOptions' => {
                  'dnsServers' => [
                    '10.1.0.5',
                    '10.1.0.6'
                  ]
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
