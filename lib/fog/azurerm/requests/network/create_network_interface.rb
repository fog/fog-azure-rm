
module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_network_interface(resource_group, name, location, subnet_id, ip_config_name, prv_ip_alloc_method)
          Fog::Logger.debug "Creating Network Interface Card: #{name}..."
          network_interface = define_network_interface(name, location, subnet_id, ip_config_name, prv_ip_alloc_method)
          begin
            promise = @network_client.network_interfaces.create_or_update(resource_group, name, network_interface)
            result = promise.value!
            Fog::Logger.debug "Network Interface #{name} created successfully."
            Azure::ARM::Network::Models::NetworkInterface.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Network Interface #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def define_network_interface(name, location, subnet_id, ip_config_name, prv_ip_alloc_method)
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.id = subnet_id

          ip_configs_props = Azure::ARM::Network::Models::NetworkInterfaceIPConfigurationPropertiesFormat.new
          ip_configs_props.private_ipallocation_method = prv_ip_alloc_method
          ip_configs_props.subnet = subnet

          ip_configs = Azure::ARM::Network::Models::NetworkInterfaceIPConfiguration.new
          ip_configs.name = ip_config_name
          ip_configs.properties = ip_configs_props

          nic_props = Azure::ARM::Network::Models::NetworkInterfacePropertiesFormat.new
          nic_props.ip_configurations = [ip_configs]

          network_interface = Azure::ARM::Network::Models::NetworkInterface.new
          network_interface.name = name
          network_interface.location = location
          network_interface.properties = nic_props

          network_interface
        end
      end

      # Mock class for Network Request
      class Mock
        def create_network_interface(resource_group, name, location, subnet_id, ip_configs_name, prv_ip_alloc_method)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/networkInterfaces',
            'location' =>  location,
            'properties' =>
              {
                'ipConfigurations' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/#{name}/ipConfigurations/#{ip_configs_name}",
                      'properties' =>
                        {
                          'privateIPAddress' => '10.0.0.5',
                          'privateIPAllocationMethod' => prv_ip_alloc_method,
                          'subnet' =>
                            {
                              'id' => subnet_id
                            },
                          'provisioningState' => 'Succeeded'
                        },
                      'name' => ip_configs_name,
                      'etag' => "W/\"e6c8e5c3-f28d-44f3-babe-0e8e934a591e\""
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
              },
            'etag' => "W/\"e6c8e5c3-f28d-44f3-babe-0e8e934a591e\""
          }
        end
      end
    end
  end
end
