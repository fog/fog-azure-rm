module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def detach_resource_from_nic(resource_group_name, network_interface_name, resource_type)
          Fog::Logger.debug "Removing #{resource_type} from Network Interface #{network_interface_name}."
          begin
            promise = @network_client.network_interfaces.get(resource_group_name, network_interface_name)
            result = promise.value!
            nic = result.body
            case resource_type
            when 'Public-IP-Address'
              nic.properties.ip_configurations[0].properties.public_ipaddress = nil unless nic.properties.ip_configurations.empty?
            when 'Network-Security-Group'
              nic.properties.network_security_group = nil
            end

            promise = @network_client.network_interfaces.create_or_update(resource_group_name, network_interface_name, nic)
            result = promise.value!
            Fog::Logger.debug "#{resource_type} deleted from Network Interface #{network_interface_name} successfully!"
            Azure::ARM::Network::Models::NetworkInterface.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception removing #{resource_type} from Network Interface #{network_interface_name} . #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def detach_resource_from_nic(resource_group_name, network_interface_name, _resource_type)
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
