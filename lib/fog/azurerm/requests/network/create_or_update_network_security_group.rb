module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_network_security_group(resource_group_name, security_group_name, location, security_rules, tags)
          msg = "Creating/Updating Network Security Group #{security_group_name} in Resource Group #{resource_group_name}."
          Fog::Logger.debug msg

          security_group = get_security_group_object(security_rules, location, tags)

          begin
            security_group = @network_client.network_security_groups.begin_create_or_update(resource_group_name, security_group_name, security_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Network Security Group #{security_group_name} Created/Updated Successfully!"
          security_group
        end

        private

        def get_security_group_object(security_rules, location, tags)
          security_group = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkSecurityGroup.new
          security_group.security_rules = get_security_rule_objects(security_rules)
          security_group.location = location
          security_group.tags = tags
          security_group
        end

        def get_security_rule_objects(security_rules)
          rules = []
          security_rules.each do |sr|
            security_rule = Azure::Network::Profiles::Latest::Mgmt::Models::SecurityRule.new
            security_rule.description = sr[:description] unless sr[:description].nil?
            security_rule.protocol = sr[:protocol]
            security_rule.source_port_range = sr[:source_port_range]
            security_rule.destination_port_range = sr[:destination_port_range]
            security_rule.source_address_prefix = sr[:source_address_prefix]
            security_rule.destination_address_prefix = sr[:destination_address_prefix]
            security_rule.access = sr[:access]
            security_rule.priority = sr[:priority]
            security_rule.direction = sr[:direction]
            security_rule.name = sr[:name]
            rules << security_rule
          end unless security_rules.nil?
          rules
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_network_security_group(resource_group_name, security_group_name, location, security_rules)
          network_security_group = {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/#{security_group_name}",
            'name' => security_group_name,
            'type' => 'Microsoft.Network/networkSecurityGroups',
            'location' => location,
            'properties' =>
              {
                'securityRules' => security_rules,
                'defaultSecurityRules' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/#{security_group_name}/defaultSecurityRules/AllowVnetInBound",
                      'properties' =>
                        {
                          'protocol' => '*',
                          'sourceAddressPrefix' => 'VirtualNetwork',
                          'destinationAddressPrefix' => 'VirtualNetwork',
                          'access' => 'Allow',
                          'direction' => 'Inbound',
                          'description' => 'Allow inbound traffic from all VMs in VNET',
                          'sourcePortRange' => '*',
                          'destinationPortRange' => '*',
                          'priority' => 65_000,
                          'provisioningState' => 'Updating'
                        },
                      'name' => 'AllowVnetInBound'
                    },
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/#{security_group_name}/defaultSecurityRules/AllowAzureLoadBalancerInBound",
                      'properties' =>
                        {
                          'protocol' => '*',
                          'sourceAddressPrefix' => 'AzureLoadBalancer',
                          'destinationAddressPrefix' => '*',
                          'access' => 'Allow',
                          'direction' => 'Inbound',
                          'description' => 'Allow inbound traffic from azure load balancer',
                          'sourcePortRange' => '*',
                          'destinationPortRange' => '*',
                          'priority' => 65_001,
                          'provisioningState' => 'Updating'
                        },
                      'name' => 'AllowAzureLoadBalancerInBound'
                    },
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/#{security_group_name}/defaultSecurityRules/DenyAllInBound",
                      'properties' =>
                        {
                          'protocol' => '*',
                          'sourceAddressPrefix' => '*',
                          'destinationAddressPrefix' => '*',
                          'access' => 'Deny',
                          'direction' => 'Inbound',
                          'description' => 'Deny all inbound traffic',
                          'sourcePortRange' => '*',
                          'destinationPortRange' => '*',
                          'priority' => 65_500,
                          'provisioningState' => 'Updating'
                        },
                      'name' => 'DenyAllInBound'
                    },
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/#{security_group_name}/defaultSecurityRules/AllowVnetOutBound",
                      'properties' =>
                        {
                          'protocol' => '*',
                          'sourceAddressPrefix' => 'VirtualNetwork',
                          'destinationAddressPrefix' => 'VirtualNetwork',
                          'access' => 'Allow',
                          'direction' => 'Outbound',
                          'description' => 'Allow outbound traffic from all VMs to all VMs in VNET',
                          'sourcePortRange' => '*',
                          'destinationPortRange' => '*',
                          'priority' => 65_000,
                          'provisioningState' => 'Updating'
                        },
                      'name' => 'AllowVnetOutBound'
                    },
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/#{security_group_name}/defaultSecurityRules/AllowInternetOutBound",
                      'properties' =>
                        {
                          'protocol' => '*',
                          'sourceAddressPrefix' => '*',
                          'destinationAddressPrefix' => 'Internet',
                          'access' => 'Allow',
                          'direction' => 'Outbound',
                          'description' => 'Allow outbound traffic from all VMs to Internet',
                          'sourcePortRange' => '*',
                          'destinationPortRange' => '*',
                          'priority' => 65_001,
                          'provisioningState' => 'Updating'
                        },
                      'name' => 'AllowInternetOutBound'
                    },
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/#{security_group_name}/defaultSecurityRules/DenyAllOutBound",
                      'properties' =>
                        {
                          'protocol' => '*',
                          'sourceAddressPrefix' => '*',
                          'destinationAddressPrefix' => '*',
                          'access' => 'Deny',
                          'direction' => 'Outbound',
                          'description' => 'Deny all outbound traffic',
                          'sourcePortRange' => '*',
                          'destinationPortRange' => '*',
                          'priority' => 65_500,
                          'provisioningState' => 'Updating'
                        },
                      'name' => 'DenyAllOutBound'
                    }
                  ],
                'resourceGuid' => '9dca97e6-4789-4ebd-86e3-52b8b0da6cd4',
                'provisioningState' => 'Updating'
              }
          }
          nsg_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkSecurityGroup.mapper
          @network_client.deserialize(nsg_mapper, network_security_group, 'result.body')
        end
      end
    end
  end
end
