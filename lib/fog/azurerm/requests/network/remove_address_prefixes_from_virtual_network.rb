module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def remove_address_prefixes_from_virtual_network(resource_group_name, virtual_network_name, address_prefixes_hash)
          Fog::Logger.debug "Removing Address Prefixes: #{address_prefixes_hash.join(', ')} from Virtual Network: #{virtual_network_name}"
          virtual_network = get_virtual_network_object_for_remove_address_prefixes!(resource_group_name, virtual_network_name, address_prefixes_hash)
          result = create_or_update_vnet(resource_group_name, virtual_network_name, virtual_network)
          Fog::Logger.debug "Address Prefixes: #{address_prefixes_hash.join(', ')} removed successfully."
          Azure::ARM::Network::Models::VirtualNetwork.serialize_object(result)
        end

        private

        def get_virtual_network_object_for_remove_address_prefixes!(resource_group_name, virtual_network_name, address_prefixes_hash)
          virtual_network = get_vnet(resource_group_name, virtual_network_name)
          attached_address_prefixes = virtual_network.properties.address_space.address_prefixes
          raise "Cannot remove Address Prefixes: Provided Address Prefix(es) is/are not found in Virtual Network: #{virtual_network_name}" if (attached_address_prefixes & address_prefixes_hash).empty?
          virtual_network.properties.address_space.address_prefixes = attached_address_prefixes - address_prefixes_hash
          virtual_network
        end
      end

      # Mock class for Network Request
      class Mock
        def remove_address_prefixes_from_virtual_network(*)
          {
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
                        '10.1.0.0/16'
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
        end
      end
    end
  end
end
