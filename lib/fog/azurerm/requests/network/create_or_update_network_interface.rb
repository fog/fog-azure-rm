
module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_network_interface(resource_group_name, name, location, subnet_id, public_ip_address_id, ip_config_name, private_ip_allocation_method, private_ip_address)
          msg = "Creating/Updating Network Interface Card: #{name}"
          Fog::Logger.debug msg
          network_interface = get_network_interface_object(name, location, subnet_id, public_ip_address_id, ip_config_name, private_ip_allocation_method, private_ip_address)
          begin
            network_interface_obj = @network_client.network_interfaces.create_or_update(resource_group_name, name, network_interface)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Network Interface #{name} created/updated successfully."
          network_interface_obj
        end

        private

        def get_network_interface_object(name, location, subnet_id, public_ip_address_id, ip_config_name, private_ip_allocation_method, private_ip_address)
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.id = subnet_id

          if public_ip_address_id
            public_ipaddress = Azure::ARM::Network::Models::PublicIPAddress.new
            public_ipaddress.id = public_ip_address_id
          end

          ip_configs = Azure::ARM::Network::Models::NetworkInterfaceIPConfiguration.new
          ip_configs.name = ip_config_name
          ip_configs.private_ipallocation_method = private_ip_allocation_method
          ip_configs.private_ipaddress = private_ip_address
          ip_configs.public_ipaddress = public_ipaddress unless public_ip_address_id.nil?
          ip_configs.subnet = subnet

          network_interface = Azure::ARM::Network::Models::NetworkInterface.new
          network_interface.name = name
          network_interface.location = location
          network_interface.ip_configurations = [ip_configs]

          network_interface
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_network_interface(resource_group_name, name, location, subnet_id, public_ip_address_id, ip_configs_name, private_ip_allocation_method, private_ip_address)
          nic = {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkInterfaces/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/networkInterfaces',
            'location' => location,
            'properties' =>
              {
                'ipConfigurations' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkInterfaces/#{name}/ipConfigurations/#{ip_configs_name}",
                      'properties' =>
                        {
                          'privateIPAddress' => private_ip_address,
                          'privateIPAllocationMethod' => private_ip_allocation_method,
                          'subnet' =>
                            {
                              'id' => subnet_id
                            },
                          'publicIPAddress' =>
                            {
                              'id' => public_ip_address_id
                            },
                          'provisioningState' => 'Succeeded'
                        },
                      'name' => ip_configs_name
                    }
                  ],
                'dnsSettings' =>
                  {
                    'dnsServers' => [],
                    'appliedDnsServers' => []
                  },
                'enableIPForwarding' => false,
                'resourceGuid' => '2bff0fad-623b-4773-82b8-dc875f3aacd2',
                'provisioningState' => 'Succeeded'
              }
          }
          network_interface_mapper = Azure::ARM::Network::Models::NetworkInterface.mapper
          @network_client.deserialize(network_interface_mapper, nic, 'result.body')
        end
      end
    end
  end
end
