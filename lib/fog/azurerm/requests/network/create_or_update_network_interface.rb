
module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_network_interface(resource_group_name, name, location, subnet_id, public_ip_address_id, network_security_group_id, ip_config_name, private_ip_allocation_method, private_ip_address, load_balancer_backend_address_pools_ids, load_balancer_inbound_nat_rules_ids, tags, enable_accelerated_networking = false, async = false)
          msg = "Creating/Updating Network Interface Card: #{name}"
          Fog::Logger.debug msg
          network_interface = get_network_interface_object(name, location, subnet_id, public_ip_address_id, network_security_group_id, ip_config_name, private_ip_allocation_method, private_ip_address, load_balancer_backend_address_pools_ids, load_balancer_inbound_nat_rules_ids, tags, enable_accelerated_networking)
          begin
            nic_response = if async
                             @network_client.network_interfaces.create_or_update_async(resource_group_name, name, network_interface)
                           else
                             @network_client.network_interfaces.create_or_update(resource_group_name, name, network_interface)
                           end
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Network Interface #{name} created/updated successfully." unless async
          nic_response
        end

        private

        def get_network_interface_object(name, location, subnet_id, public_ip_address_id, network_security_group_id, ip_config_name, private_ip_allocation_method, private_ip_address, load_balancer_backend_address_pools_ids, load_balancer_inbound_nat_rules_ids, tags, enable_accelerated_networking)
          if public_ip_address_id
            public_ipaddress = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddress.new
            public_ipaddress.id = public_ip_address_id
          end

          ip_configs = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkInterfaceIPConfiguration.new
          ip_configs.name = ip_config_name
          ip_configs.private_ipallocation_method = private_ip_allocation_method
          ip_configs.private_ipaddress = private_ip_address
          ip_configs.public_ipaddress = public_ipaddress unless public_ip_address_id.nil?

          if subnet_id
            subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
            subnet.id = subnet_id
            ip_configs.subnet = subnet
          end

          if load_balancer_backend_address_pools_ids
            ip_configs.load_balancer_backend_address_pools = []
            load_balancer_backend_address_pools_ids.each do |load_balancer_backend_address_pools_id|
              backend_pool = Azure::Network::Profiles::Latest::Mgmt::Models::BackendAddressPool.new
              backend_pool.id = load_balancer_backend_address_pools_id
              ip_configs.load_balancer_backend_address_pools.push(backend_pool)
            end
          end

          if load_balancer_inbound_nat_rules_ids
            ip_configs.load_balancer_inbound_nat_rules = []
            load_balancer_inbound_nat_rules_ids.each do |load_balancer_inbound_nat_rules_id|
              inbound_nat_rule = Azure::Network::Profiles::Latest::Mgmt::Models::InboundNatRule.new
              inbound_nat_rule.id = load_balancer_inbound_nat_rules_id
              ip_configs.load_balancer_inbound_nat_rules.push(inbound_nat_rule)
            end
          end

          network_interface = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkInterface.new
          network_interface.name = name
          network_interface.location = location
          network_interface.ip_configurations = [ip_configs]
          network_interface.tags = tags
          network_interface.enable_accelerated_networking = enable_accelerated_networking

          if network_security_group_id
            network_security_group = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkSecurityGroup.new
            network_security_group.id = network_security_group_id
            network_interface.network_security_group = network_security_group
          end

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
          network_interface_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkInterface.mapper
          @network_client.deserialize(network_interface_mapper, nic, 'result.body')
        end
      end
    end
  end
end
