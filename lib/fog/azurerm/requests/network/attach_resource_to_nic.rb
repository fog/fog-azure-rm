module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def attach_resource_to_nic(resource_group_name, network_interface_name, resource_type, resource_id)
          Fog::Logger.debug "Updating #{resource_type} in Network Interface #{network_interface_name}."
          begin
            nic = get_network_interface_with_attached_resource(network_interface_name, resource_group_name, resource_id, resource_type)

            promise = @network_client.network_interfaces.create_or_update(resource_group_name, network_interface_name, nic)
            result = promise.value!
            Fog::Logger.debug "#{resource_type} updated in Network Interface #{network_interface_name} successfully!"
            Azure::ARM::Network::Models::NetworkInterface.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception updating #{resource_type} in Network Interface #{network_interface_name} . #{e.body['error']['message']}"
            raise msg
          end
        end

        def get_network_interface_with_attached_resource(network_interface_name, resource_group_name, resource_id, resource_type)
          promise = @network_client.network_interfaces.get(resource_group_name, network_interface_name)
          result = promise.value!
          nic = result.body
          case resource_type
          when SUBNET
            subnet = Azure::ARM::Network::Models::Subnet.new
            subnet.id = resource_id
            nic.properties.ip_configurations[0].properties.subnet = subnet
          when PUBLIC_IP
            public_ip_address = Azure::ARM::Network::Models::PublicIPAddress.new
            public_ip_address.id = resource_id
            nic.properties.ip_configurations[0].properties.public_ipaddress = public_ip_address
          when NETWORK_SECURITY_GROUP
            network_security_group = Azure::ARM::Network::Models::NetworkSecurityGroup.new
            network_security_group.id = resource_id
            nic.properties.network_security_group = network_security_group
          end
          nic
        end
      end

      # Mock class for Network Request
      class Mock
        def attach_resource_to_nic(resource_group_name, network_interface_name, _resource_type, _resource_id)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkInterfaces/#{network_interface_name}",
            'name' => network_interface_name,
            'type' => 'Microsoft.Network/networkInterfaces',
            'location' => location,
            'properties' =>
              {
                'ipConfigurations' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkInterfaces/#{network_interface_name}/ipConfigurations/#{ip_configs_name}",
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
        end
      end
    end
  end
end
