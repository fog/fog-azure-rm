module Fog
  module Sql
    class AzureRM
      # Sql Server Collection for Firewall Rules Service
      class FirewallRules < Fog::Collection
        attribute :resource_group
        attribute :server_name
        model FirewallRule

        def all
          requires :resource_group, :server_name

          firewall_rules = []
          service.list_firewall_rules(resource_group, server_name).each do |firewall_rule|
            firewall_rules << FirewallRule.parse(firewall_rule)
          end
          load(firewall_rules)
        end

        def get(resource_group, server_name, rule_name)
          firewall_rule = service.get_firewall_rule(resource_group, server_name, rule_name)
          firewall_rule_obj = FirewallRule.new(service: service)
          firewall_rule_obj.merge_attributes(FirewallRule.parse(firewall_rule))
        end
      end
    end
  end
end
