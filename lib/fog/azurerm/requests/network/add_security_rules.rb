module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def add_security_rules(resource_group_name, security_group_name, security_rules)
          msg = "Updating security rules in Network Security Group #{security_group_name}."
          Fog::Logger.debug msg

          nsg = @network_client.network_security_groups.get(resource_group_name, security_group_name)
          security_rules_objects = get_security_rule_objects(security_rules)

          security_rules_objects.each do |security_rule|
            nsg.security_rules.push(security_rule)
          end

          begin
            nsg = @network_client.network_security_groups.begin_create_or_update(resource_group_name, security_group_name, nsg)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Security Rules updated in Network Security Group #{security_group_name} successfully!"
          nsg
        end
      end

      # Mock class for Network Request
      class Mock
        def add_security_rules(resource_group_name, security_group_name, security_rules)
          network_security_group = {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/#{security_group_name}",
            'name' => security_group_name,
            'type' => 'Microsoft.Network/networkSecurityGroups',
            'location' => 'location',
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
