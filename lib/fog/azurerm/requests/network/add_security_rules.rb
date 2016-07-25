module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def add_security_rules(resource_group, name, security_rules)
          Fog::Logger.debug "Updating security rules in Network Security Group #{name}."
          promise = @network_client.network_security_groups.get(resource_group, name)
          result = promise.value!
          nsg = result.body
          security_rules_list = define_security_rules(security_rules)
          security_rules_list.each do |sr|
            nsg.properties.security_rules.push(sr)
          end

          begin
            promise = @network_client.network_security_groups.begin_create_or_update(resource_group, name, nsg)
            result = promise.value!
            Fog::Logger.debug "Security Rules updated in Network Security Group #{name} successfully!"
            Azure::ARM::Network::Models::NetworkSecurityGroup.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception updating Security Rules in Network Security Group #{name} . #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def add_security_rules(resource_group, name, _security_rules)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/networkSecurityGroups',
            'location' => 'location',
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
