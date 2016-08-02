module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def remove_subnets_from_virtual_network(resource_group_name, virtual_network_name, subnet_names_array)
          Fog::Logger.debug "Removing Subnets:#{subnet_names_array.join(', ')} from Virtual Network: #{virtual_network_name}"

          virtual_network = get_virtual_network_object_for_remove_subnets!(resource_group_name, virtual_network_name, subnet_names_array)
          begin
            promise = @network_client.virtual_networks.create_or_update(resource_group_name, virtual_network_name, virtual_network)
            result = promise.value!
            Fog::Logger.debug "Subnets:#{subnet_names_array.join(', ')} removed successfully."
            Azure::ARM::Network::Models::VirtualNetwork.serialize_object(result.body)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception removing Subnets:#{subnet_names_array.join(', ')} from Virtual Network: #{virtual_network_name}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def get_virtual_network_object_for_remove_subnets!(resource_group_name, virtual_network_name, subnet_names_array)
          begin
            promise = @network_client.virtual_networks.get(resource_group_name, virtual_network_name)
            result = promise.value!
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception removing Subnets:#{subnet_names_array.join(', ')} from Virtual Network: #{virtual_network_name}. #{e.body['error']['message']}"
            raise msg
          end

          virtual_network = result.body
          old_subnet_objects = virtual_network.properties.subnets
          old_subnet_names_array = virtual_network.properties.subnets.map(&:name)
          raise "Cannot remove Subnets: Provided Subnet(s) is/are not found in Virtual Network: #{virtual_network_name}" if (old_subnet_names_array & subnet_names_array).empty?
          virtual_network.properties.subnets = old_subnet_objects.reject { |subnet| subnet_names_array.include?(subnet.name) }
          virtual_network
        end
      end

      # Mock class for Network Request
      class Mock
        def remove_subnets_from_virtual_network(*)
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
                'subnets' => [],
                'resourceGuid' => 'c573f8e2-d916-493f-8b25-a681c31269ef',
                'provisioningState' => 'Succeeded'
              }
          }
        end
      end
    end
  end
end
