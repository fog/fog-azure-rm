module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def attach_route_table_to_subnet(resource_group, subnet_name, virtual_network_name, address_prefix, network_security_group_id, route_table_id)
          Fog::Logger.debug "Attaching Route Table with Subnet: #{subnet_name}."

          subnet = get_subnet_object_for_attach_route_table(address_prefix, network_security_group_id, route_table_id)
          begin
            promise = @network_client.subnets.create_or_update(resource_group, virtual_network_name, subnet_name, subnet)
            result = promise.value!
            Fog::Logger.debug 'Route Table attached successfully.'
            Azure::ARM::Network::Models::Subnet.serialize_object(result.body)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception Attaching Route Table with Subnet: #{subnet_name}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def get_subnet_object_for_attach_route_table(address_prefix, network_security_group_id, route_table_id)
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet_properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
          network_security_group = Azure::ARM::Network::Models::NetworkSecurityGroup.new
          route_table = Azure::ARM::Network::Models::RouteTable.new

          network_security_group.id = network_security_group_id
          route_table.id = route_table_id

          subnet_properties.address_prefix = address_prefix
          subnet_properties.network_security_group = network_security_group unless network_security_group_id.nil?
          subnet_properties.route_table = route_table
          subnet.properties = subnet_properties
          subnet
        end
      end

      # Mock class for Network Request
      class Mock
        def attach_route_table_to_subnet(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet',
            'properties' =>
              {
                'addressPrefix' => '10.1.0.0/24',
                'routeTable' => {
                  'id' => '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/myRT1'
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
