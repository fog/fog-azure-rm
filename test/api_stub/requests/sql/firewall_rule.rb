module ApiStub
  module Requests
    module Sql
      # Mock class for Firewall Rule
      class FirewallRule
        def self.create_firewall_rule_response(sql_manager_client)
          body = '{
            "id": "{uri-of-firewall-rule}",
            "name": "{rule-name}",
            "type": "{rule-type}",
            "location": "{server-location}",
            "properties": {
              "startIpAddress": "{start-ip-address}",
              "endIpAddress": "{end-ip-address}"
            }
          }'
          firewall_mapper = Azure::ARM::SQL::Models::ServerFirewallRule.mapper
          sql_manager_client.deserialize(firewall_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.list_firewall_rule_response(sql_manager_client)
          body = '{
            "value": [{
              "id": "{uri-of-firewall-rule}",
              "name": "{rule-name}",
              "type": "{rule-type}",
              "location": "{server-location}",
              "properties": {
                "startIpAddress": "{start-ip-address}",
                "endIpAddress": "{end-ip-address}"
              }
            }]
          }'
          firewall_mapper = Azure::ARM::SQL::Models::ServerFirewallRuleListResult.mapper
          sql_manager_client.deserialize(firewall_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.firewall_rule_hash
          {
            resource_group: 'resource_group',
            server_name: 'server_name',
            name: 'firewall_name',
            start_ip: '10.10.10.01',
            end_ip: '10.10.10.10'
          }
        end
      end
    end
  end
end
