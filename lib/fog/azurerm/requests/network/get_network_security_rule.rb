module Fog
  module Network
    class AzureRM
      # Real class for Network Security rule Request
      class Real
        def get_network_security_rule(resource_group_name, network_security_group_name, security_rule_name)
          msg = "Getting Network Security Rule #{security_rule_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg

          begin
            security_rule = @network_client.security_rules.get(resource_group_name, network_security_group_name, security_rule_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Network Security Rule #{security_rule_name} retrieved successfully."
          security_rule
        end
      end

      # Mock class for Network Security Rule Request
      class Mock
        def get_network_security_rule(*)
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
          nsr_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::SecurityRule.mapper
          @network_client.deserialize(nsr_mapper, JSON.load(nsr), 'result.body')
        end
      end
    end
  end
end
