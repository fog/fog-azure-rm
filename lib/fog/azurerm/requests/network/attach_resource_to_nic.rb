module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def attach_resource_to_nic(resource_group_name, nic_name, resource_type, resource_id)
          msg = "Updating #{resource_type} in Network Interface #{nic_name}"
          Fog::Logger.debug msg
          begin
            nic = get_network_interface_with_attached_resource(nic_name, resource_group_name, resource_id, resource_type)
            network_interface = @network_client.network_interfaces.create_or_update(resource_group_name, nic_name, nic)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "#{resource_type} updated in Network Interface #{nic_name} successfully!"
          network_interface
        end

        private

        def get_network_interface_with_attached_resource(nic_name, resource_group_name, resource_id, resource_type)
          network_interface = @network_client.network_interfaces.get(resource_group_name, nic_name)

          case resource_type
          when SUBNET
            subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
            subnet.id = resource_id
            network_interface.ip_configurations[0].subnet = subnet
          when PUBLIC_IP
            public_ip_address = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddress.new
            public_ip_address.id = resource_id
            network_interface.ip_configurations[0].public_ipaddress = public_ip_address
          when NETWORK_SECURITY_GROUP
            network_security_group = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkSecurityGroup.new
            network_security_group.id = resource_id
            network_interface.network_security_group = network_security_group
          end
          network_interface
        end
      end

      # Mock class for Network Request
      class Mock
        def attach_resource_to_nic(resource_group_name, nic_name, _resource_type, _resource_id)
          nic = {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkInterfaces/#{nic_name}",
            'name' => nic_name,
            'type' => 'Microsoft.Network/networkInterfaces',
            'location' => location,
            'properties' =>
              {
                'ipConfigurations' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkInterfaces/#{nic_name}/ipConfigurations/#{ip_configs_name}",
                      'properties' =>
                        {
                          'privateIPAddress' => '10.0.0.5',
                          'privateIPAllocationMethod' => prv_ip_alloc_method,
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
          network_interface_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkInterface.mapper
          @network_client.deserialize(network_interface_mapper, nic, 'result.body')
        end
      end
    end
  end
end
