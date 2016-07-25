module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_network_security_group(resource_group, name, location, security_rules)
          Fog::Logger.debug "Creating/Updating Network Security Group #{name} in Resource Group #{resource_group}."
          properties = Azure::ARM::Network::Models::NetworkSecurityGroupPropertiesFormat.new
          properties.security_rules = define_security_rules(security_rules)

          params = Azure::ARM::Network::Models::NetworkSecurityGroup.new
          params.location = location
          params.properties = properties
          begin
            promise = @network_client.network_security_groups.begin_create_or_update(resource_group, name, params)
            result = promise.value!
            Fog::Logger.debug "Network Security Group #{name} Created/Updated Successfully!"
            Azure::ARM::Network::Models::NetworkSecurityGroup.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating/updating Network Security Group #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def define_security_rules(security_rules)
          rules = []
          security_rules.each do |sr|
            properties = Azure::ARM::Network::Models::SecurityRulePropertiesFormat.new
            properties.description = sr[:description] unless sr[:description].nil?
            properties.protocol = sr[:protocol]
            properties.source_port_range = sr[:source_port_range]
            properties.destination_port_range = sr[:destination_port_range]
            properties.source_address_prefix = sr[:source_address_prefix]
            properties.destination_address_prefix = sr[:destination_address_prefix]
            properties.access = sr[:access]
            properties.priority = sr[:priority]
            properties.direction = sr[:direction]

            security_rule = Azure::ARM::Network::Models::SecurityRule.new
            security_rule.name = sr[:name]
            security_rule.properties = properties
            rules << security_rule
          end unless security_rules.nil?
          rules
        end
      end

      # Mock class for Network Request
      class Mock
        def create_network_security_group(resource_group, name, location, _security_rules)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/networkSecurityGroups',
            'location' => location,
            'properties' =>
              {
                'securityRules' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}/securityRules/testRule",
                      'properties' =>
                        {
                          'protocol' => 'tcp',
                          'sourceAddressPrefix' => '0.0.0.0/0',
                          'destinationAddressPrefix' => '0.0.0.0/0',
                          'access' => 'Allow',
                          'direction' => 'Inbound',
                          'sourcePortRange' => '22',
                          'destinationPortRange' => '22',
                          'priority' => 100,
                          'provisioningState' => 'Updating'
                        },
                      'name' => 'testRule'
                    }
                  ],
                'defaultSecurityRules' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}/defaultSecurityRules/AllowVnetInBound",
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
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}/defaultSecurityRules/AllowAzureLoadBalancerInBound",
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
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}/defaultSecurityRules/DenyAllInBound",
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
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}/defaultSecurityRules/AllowVnetOutBound",
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
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}/defaultSecurityRules/AllowInternetOutBound",
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
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}/defaultSecurityRules/DenyAllOutBound",
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
        end
      end
    end
  end
end
