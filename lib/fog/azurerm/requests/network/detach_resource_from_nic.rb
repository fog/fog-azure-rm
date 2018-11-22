module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def detach_resource_from_nic(resource_group_name, nic_name, resource_type)
          msg = "Removing #{resource_type} from Network Interface #{nic_name}"
          Fog::Logger.debug msg
          begin
            nic = get_network_interface_with_detached_resource(nic_name, resource_group_name, resource_type)

            nic_obj = @network_client.network_interfaces.create_or_update(resource_group_name, nic_name, nic)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "#{resource_type} deleted from Network Interface #{nic_name} successfully!"
          nic_obj
        end

        private

        def get_network_interface_with_detached_resource(nic_name, resource_group_name, resource_type)
          network_interface = @network_client.network_interfaces.get(resource_group_name, nic_name)
          case resource_type
          when PUBLIC_IP
            network_interface.ip_configurations[0].public_ipaddress = nil unless network_interface.ip_configurations.empty?
          when NETWORK_SECURITY_GROUP
            network_interface.network_security_group = nil
          end
          network_interface
        end
      end

      # Mock class for Network Request
      class Mock
        def detach_resource_from_nic(resource_group_name, nic_name, _resource_type)
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
