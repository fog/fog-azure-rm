module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_subnet(resource_group, subnet_name, virtual_network_name, address_prefix, network_security_group_id, route_table_id)
          msg = "Creating Subnet: #{subnet_name}"
          Fog::Logger.debug msg
          subnet = get_subnet_object(address_prefix, network_security_group_id, route_table_id)
          begin
            subnet_obj = @network_client.subnets.create_or_update(resource_group, virtual_network_name, subnet_name, subnet)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Subnet #{subnet_name} created successfully."
          subnet_obj
        end

        private

        def get_subnet_object(address_prefix, network_security_group_id, route_table_id)
          subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
          network_security_group = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkSecurityGroup.new
          route_table = Azure::Network::Profiles::Latest::Mgmt::Models::RouteTable.new

          subnet.address_prefix = address_prefix
          network_security_group.id = network_security_group_id
          route_table.id = route_table_id

          subnet.network_security_group = network_security_group unless network_security_group_id.nil?
          subnet.route_table = route_table unless route_table_id.nil?
          subnet
        end
      end

      # Mock class for Network Request
      class Mock
        def create_subnet(*)
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
