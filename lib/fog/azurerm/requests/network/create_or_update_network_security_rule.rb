module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_network_security_rule(security_rule)
          msg = "Creating/Updating Network Security Rule #{security_rule[:name]} in Resource Group #{security_rule[:resource_group]}."
          Fog::Logger.debug msg
          security_rule_params = get_security_rule_params(security_rule)
          begin
            security_rule_obj = @network_client.security_rules.create_or_update(security_rule[:resource_group], security_rule[:network_security_group_name], security_rule[:name], security_rule_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Network Security Rule #{security_rule[:name]} Created/Updated Successfully!"
          security_rule_obj
        end

        def get_security_rule_params(security_rule_hash)
          security_rule = Azure::Network::Profiles::Latest::Mgmt::Models::SecurityRule.new
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
          network_security_rule = '{
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
          network_security_rule_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::SecurityRule.mapper
          @network_client.deserialize(network_security_rule_mapper, JSON.load(network_security_rule), 'result.body')
        end
      end
    end
  end
end
