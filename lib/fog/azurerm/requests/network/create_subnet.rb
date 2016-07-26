module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_subnet(resource_group, name, virtual_network_name, address_prefix, network_security_group_id, route_table_id)
          Fog::Logger.debug "Creating Subnet: #{name}."

          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet_properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
          network_security_group = Azure::ARM::Network::Models::NetworkSecurityGroup.new
          route_table = Azure::ARM::Network::Models::RouteTable.new

          subnet.name = name
          subnet_properties.address_prefix = address_prefix

          network_security_group.id = network_security_group_id
          route_table.id = route_table_id

          subnet_properties.network_security_group = network_security_group unless network_security_group_id.nil?
          subnet_properties.route_table = route_table unless route_table_id.nil?

          subnet.properties = subnet_properties
          begin
            promise = @network_client.subnets.create_or_update(resource_group, virtual_network_name, name, subnet)
            result = promise.value!
            Fog::Logger.debug "Subnet #{name} created successfully."
            Azure::ARM::Network::Models::Subnet.serialize_object(result.body)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception creating Subnet #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def create_subnet(*)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet",
            'properties' =>
              {
                'addressPrefix' => '10.1.0.0/24',
                'provisioningState' => 'Succeeded'
              },
            'name' => 'fog-subnet'
          }
        end
      end
    end
  end
end
