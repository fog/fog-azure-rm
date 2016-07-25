module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def remove_security_rule(resource_group, security_group_name, security_rule_name)
          Fog::Logger.debug "Deleting security rule #{security_rule_name} from Network Security Group #{security_group_name}."
          promise = @network_client.network_security_groups.get(resource_group, security_group_name)
          result = promise.value!
          nsg = result.body
          updated_security_rule_list = remove_security_rule_from_list(nsg.properties.security_rules, security_rule_name)
          nsg.properties.security_rules = updated_security_rule_list
          begin
            promise = @network_client.network_security_groups.begin_create_or_update(resource_group, security_group_name, nsg)
            result = promise.value!
            Fog::Logger.debug "Security Rule #{security_rule_name} deleted from Network Security Group #{security_group_name} successfully!"
            Azure::ARM::Network::Models::NetworkSecurityGroup.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception in deleting Security Rule #{security_rule_name} from Network Security Group #{security_group_name} . #{e.body['error']['message']}"
            raise msg
          end
        end

        def remove_security_rule_from_list(security_rule_list, rule_name)
          unless security_rule_list.nil?
            return security_rule_list.select { |sr| sr.name != rule_name }
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def remove_security_rule(resource_group, name, _security_rules)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/networkSecurityGroups',
            'location' => 'location',
            'properties' =>
              {
                'securityRules' => [],
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
