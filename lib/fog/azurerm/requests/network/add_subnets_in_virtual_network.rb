module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def add_subnets_in_virtual_network(resource_group_name, virtual_network_name, new_subnets)
          Fog::Logger.debug "Adding Subnets: in Virtual Network: #{virtual_network_name}"
          virtual_network = get_virtual_network_object_for_subnets!(resource_group_name, virtual_network_name, new_subnets)
          result = create_or_update_vnet(resource_group_name, virtual_network_name, virtual_network)
          Fog::Logger.debug 'Subnets added successfully.'
          Azure::ARM::Network::Models::VirtualNetwork.serialize_object(result)
        end

        private

        def get_virtual_network_object_for_subnets!(resource_group_name, virtual_network_name, new_subnets)
          virtual_network = get_vnet(resource_group_name, virtual_network_name)
          new_subnet_objects = define_subnet_objects(new_subnets)
          old_subnet_objects = virtual_network.properties.subnets

          subnet_exist = new_subnet_objects.map(&:name) & old_subnet_objects.map(&:name)
          raise "Cannot add Subnets: Provided Subnet(s) is/are already added in Virtual Network: #{virtual_network_name}" if subnet_exist.any?

          virtual_network.properties.subnets = new_subnet_objects + old_subnet_objects
          virtual_network
        end
      end

      # Mock class for Network Request
      class Mock
        def add_subnets_in_virtual_network(*)
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
