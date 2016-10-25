module ApiStub
  module Requests
    module Sql
      # Mock class for Firewall Rule
      class FirewallRule
        def self.create_firewall_rule_response
          '{
            "id": "{uri-of-firewall-rule}",
            "name": "{rule-name}",
            "type": "{rule-type}",
            "location": "{server-location}",
            "properties": {
              "startIpAddress": "{start-ip-address}",
              "endIpAddress": "{end-ip-address}"
            }
          }'
        end

        def self.list_firewall_rule_response
          '{
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
