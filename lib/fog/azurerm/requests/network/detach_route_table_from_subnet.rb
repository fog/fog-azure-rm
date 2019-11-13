module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def detach_route_table_from_subnet(resource_group, subnet_name, virtual_network_name, address_prefix, network_security_group_id)
          msg = "Detaching Route Table from Subnet: #{subnet_name}"
          Fog::Logger.debug msg
          subnet = get_subnet_object_for_detach_route_table(address_prefix, network_security_group_id)
          begin
            subnet = @network_client.subnets.create_or_update(resource_group, virtual_network_name, subnet_name, subnet)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug 'Route Table detached successfully.'
          subnet
        end

        private

        def get_subnet_object_for_detach_route_table(address_prefix, network_security_group_id)
          subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
          network_security_group = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkSecurityGroup.new

          network_security_group.id = network_security_group_id
          subnet.address_prefix = address_prefix
          subnet.network_security_group = network_security_group unless network_security_group_id.nil?
          subnet.route_table = nil
          subnet
        end
      end

      # Mock class for Network Request
      class Mock
        def detach_route_table_from_subnet(*)
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
