module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def remove_dns_servers_from_virtual_network(resource_group_name, virtual_network_name, dns_servers_hash)
          Fog::Logger.debug "Removing DNS Servers: #{dns_servers_hash.join(', ')} from Virtual Network: #{virtual_network_name}"
          virtual_network = get_virtual_network_object_for_remove_dns_servers!(resource_group_name, virtual_network_name, dns_servers_hash)
          result = create_or_update_vnet(resource_group_name, virtual_network_name, virtual_network)
          Fog::Logger.debug "DNS Servers: #{dns_servers_hash.join(', ')} removed successfully."
          Azure::ARM::Network::Models::VirtualNetwork.serialize_object(result)
        end

        private

        def get_virtual_network_object_for_remove_dns_servers!(resource_group_name, virtual_network_name, dns_servers_hash)
          virtual_network = get_vnet(resource_group_name, virtual_network_name)
          attached_dns_servers = virtual_network.properties.dhcp_options.dns_servers
          raise "Cannot remove DNS Servers: Provided DNS Server(s) is/are not found in Virtual Network: #{virtual_network_name}" if (attached_dns_servers & dns_servers_hash).empty?
          virtual_network.properties.dhcp_options.dns_servers = attached_dns_servers - dns_servers_hash
          virtual_network
        end
      end

      # Mock class for Network Request
      class Mock
        def remove_dns_servers_from_virtual_network(*)
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
                        '10.1.0.0/16',
                        '10.2.0.0/16'
                      ]
                  },
                'dhcpOptions' => {
                  'dnsServers' => [
                    '10.1.0.5'
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
