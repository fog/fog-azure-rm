module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def detach_network_security_group_from_subnet(resource_group, subnet_name, virtual_network_name, address_prefix, route_table_id)
          msg = "Detaching Network Security Group from Subnet: #{subnet_name}"
          Fog::Logger.debug msg
          subnet = get_subnet_object_for_detach_network_security_group(address_prefix, route_table_id)
          begin
            subnet = @network_client.subnets.create_or_update(resource_group, virtual_network_name, subnet_name, subnet)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug 'Network Security Group detached successfully.'
          subnet
        end

        private

        def get_subnet_object_for_detach_network_security_group(address_prefix, route_table_id)
          subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
          route_table = Azure::Network::Profiles::Latest::Mgmt::Models::RouteTable.new

          route_table.id = route_table_id
          subnet.address_prefix = address_prefix
          subnet.route_table = route_table unless route_table_id.nil?
          subnet.network_security_group = nil
          subnet
        end
      end

      # Mock class for Network Request
      class Mock
        def detach_network_security_group_from_subnet(*)
          subnet = {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet',
            'properties' =>
              {
                'addressPrefix' => '10.1.0.0/24',
                'provisioningState' => 'Succeeded'
              },
            'name' => 'fog-subnet'
          }
          subnet_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.mapper
          @network_client.deserialize(subnet_mapper, subnet, 'result.body')
        end
      end
    end
  end
end
