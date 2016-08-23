module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def attach_network_security_group_to_subnet(resource_group, subnet_name, virtual_network_name, address_prefix, route_table_id, network_security_group_id)
          Fog::Logger.debug "Attaching Network Security Group with Subnet: #{subnet_name}."
          subnet = get_subnet_object_for_attach_network_security_group(address_prefix, network_security_group_id, route_table_id)
          begin
            result = @network_client.subnets.create_or_update(resource_group, virtual_network_name, subnet_name, subnet)
            Fog::Logger.debug 'Network Security Group attached successfully.'
            result
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, "Attaching Network Security Group with Subnet: #{subnet_name}")
          end
        end

        private

        def get_subnet_object_for_attach_network_security_group(address_prefix, network_security_group_id, route_table_id)
          subnet = Azure::ARM::Network::Models::Subnet.new
          network_security_group = Azure::ARM::Network::Models::NetworkSecurityGroup.new
          route_table = Azure::ARM::Network::Models::RouteTable.new

          network_security_group.id = network_security_group_id
          route_table.id = route_table_id

          subnet.address_prefix = address_prefix
          subnet.route_table = route_table unless route_table_id.nil?
          subnet.network_security_group = network_security_group
          subnet
        end
      end

      # Mock class for Network Request
      class Mock
        def attach_network_security_group_to_subnet(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet',
            'properties' =>
              {
                'addressPrefix' => '10.1.0.0/24',
                'networkSecurityGroup' => {
                  'id' => '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNSG1'
                },
                'provisioningState' => 'Succeeded'
              },
            'name' => 'fog-subnet'
          }
        end
      end
    end
  end
end
