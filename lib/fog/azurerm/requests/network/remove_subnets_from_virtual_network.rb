module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def remove_subnets_from_virtual_network(resource_group_name, virtual_network_name, subnet_names)
          Fog::Logger.debug "Removing Subnets:#{subnet_names.join(', ')} from Virtual Network: #{virtual_network_name}"
          virtual_network = get_virtual_network_object_for_remove_subnets!(resource_group_name, virtual_network_name, subnet_names)
          result = create_or_update_vnet(resource_group_name, virtual_network_name, virtual_network)
          Fog::Logger.debug "Subnets:#{subnet_names.join(', ')} removed successfully."
          result
        end

        private

        def get_virtual_network_object_for_remove_subnets!(resource_group_name, virtual_network_name, subnet_names)
          virtual_network = get_vnet(resource_group_name, virtual_network_name)
          old_subnet_objects = virtual_network.subnets
          virtual_network.subnets = old_subnet_objects.reject { |subnet| subnet_names.include?(subnet.name) }
          virtual_network
        end
      end

      # Mock class for Network Request
      class Mock
        def remove_subnets_from_virtual_network(*)
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
                'subnets' => [],
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
