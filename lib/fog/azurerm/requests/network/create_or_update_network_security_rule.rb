module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_network_security_rule(security_rule_hash)
          msg = "Creating/Updating Network Security Rule #{security_rule_hash[:name]} in Resource Group #{security_rule_hash[:resource_group]}."
          Fog::Logger.debug msg
          security_rule_params = get_security_rule_params(security_rule_hash)
          begin
            security_rule = @network_client.security_rules.create_or_update(security_rule_hash[:resource_group], security_rule_hash[:network_security_group_name], security_rule_hash[:name], security_rule_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Network Security Rule #{security_rule_hash[:name]} Created/Updated Successfully!"
          security_rule
        end

        def get_security_rule_params(security_rule_hash)
          security_rule = Azure::ARM::Network::Models::SecurityRule.new
          security_rule.protocol = security_rule_hash[:protocol]
          security_rule.source_port_range = security_rule_hash[:source_port_range]
          security_rule.destination_port_range = security_rule_hash[:destination_port_range]
          security_rule.source_address_prefix = security_rule_hash[:source_address_prefix]
          security_rule.destination_address_prefix = security_rule_hash[:destination_address_prefix]
          security_rule.access = security_rule_hash[:access]
          security_rule.priority = security_rule_hash[:priority]
          security_rule.direction = security_rule_hash[:direction]
          security_rule
        end
      end

      # Mock class for Network Security Rule Request
      class Mock
        def create_or_update_network_security_rule(*)
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
          @network_client.deserialize(nsr_mapper, JSON.load(nsr), 'result.body')
        end
      end
    end
  end
end
