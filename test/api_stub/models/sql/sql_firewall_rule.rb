module ApiStub
  module Models
    module Sql
      # Mock class for Firewall Rule
      class SqlFirewallRule
        # This class contain mock
        def self.create_firewall_rule
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/{resource-group-name}/providers/Microsoft.Sql/servers/{server-name}/firewallRules/{rule-name}",
            'name' => '{rule-name}',
            'type' => '{rule-type}',
            'location' => '{server-location}',
            'properties' => {
              'startIpAddress' => '{start-ip-address}',
              'endIpAddress' => '{end-ip-address}'
            }
          }
        end
      end
    end
  end
end
