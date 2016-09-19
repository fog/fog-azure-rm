module ApiStub
  module Requests
    module Network
      # Mock class for Network Security Rule Request
      class NetworkSecurityRule
        def self.create_network_security_rule_response(network_client)
          nsr = '{
              "name":"myNsRule",
              "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNsg/securityRules/myNsRule",
              "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
              "properties":{
                "provisioningState":"Succeeded",
                "description":"description-of-this-rule",
                "protocol": "*",
                "sourcePortRange":"source-port-range",
                "destinationPortRange":"destination-port-range",
                "sourceAddressPrefix":"*",
                "destinationAddressPrefix":"*",
                "access":"Allow",
                "priority":6500,
                "direction":"Inbound"
              }
          }'
          nsr_mapper = Azure::ARM::Network::Models::SecurityRule.mapper
          network_client.deserialize(nsr_mapper, JSON.load(nsr), 'result.body')
        end

        def self.network_security_rule_paramteres_hash
          {
            name: 'testRule',
            resource_group: 'TestRG-NSR',
            protocol: 'tcp',
            network_security_group_name: 'testGroup',
            source_port_range: '22',
            destination_port_range: '22',
            source_address_prefix: '0.0.0.0/0',
            destination_address_prefix: '0.0.0.0/0',
            access: 'Allow',
            priority: '100',
            direction: 'Inbound'
          }
        end

        def self.list_network_security_rules(network_client)
          nsr_list = '{
            "value":[
              {
                "name":"myNsRule",
                "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNsg/securityRules/myNsRule",
                "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                "properties":{
                  "provisioningState":"Succeeded",
                  "description":"description-of-this-rule",
                  "protocol": "*",
                  "sourcePortRange":"source-port-range",
                  "destinationPortRange":"destination-port-range",
                  "sourceAddressPrefix":"*",
                  "destinationAddressPrefix":"*",
                  "access":"Allow",
                  "priority":100,
                  "direction":"Inbound"
                }
              }
          ]
          }'
          nsr_mapper = Azure::ARM::Network::Models::SecurityRuleListResult.mapper
          network_client.deserialize(nsr_mapper, JSON.load(nsr_list), 'result.body')
        end
      end
    end
  end
end

