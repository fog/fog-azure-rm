module ApiStub
  module Models
    module Network
      # Mock class for Network Security Rule Model
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
      end
    end
  end
end
