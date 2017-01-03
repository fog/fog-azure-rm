module ApiStub
  module Models
    module Sql
      # Mock class for Firewall Rule
      class SqlFirewallRule
        # This class contain mock
        def self.create_firewall_rule(firewall_manager_client)
          firewall_rule = '{
            "id" : "/subscriptions/########-####-####-####-############/resourceGroups/{resource-group-name}/providers/Microsoft.Sql/servers/{server-name}/firewallRules/{rule-name}",
            "name" : "{rule-name}",
            "type" : "{rule-type}",
            "location" : "{server-location}",
            "properties" : {
              "startIpAddress" : "{start-ip-address}",
              "endIpAddress" : "{end-ip-address}"
            }
          }'
          firewall_rule_mapper = Azure::ARM::SQL::Models::ServerFirewallRule.mapper
          firewall_manager_client.deserialize(firewall_rule_mapper, Fog::JSON.decode(firewall_rule), 'result.body')
        end
      end
    end
  end
end
