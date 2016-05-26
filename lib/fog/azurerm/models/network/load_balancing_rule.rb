module Fog
  module Network
    class AzureRM
      # LoadBalangcingRule model for Network Service
      class LoadBalangcingRule < Fog::Model
        identity :name
        attribute :id
        attribute :frontend_ip_configuration_id
        attribute :backend_address_pool_id
        attribute :protocol
        attribute :frontend_port
        attribute :backend_port
        attribute :probe_id
        attribute :enable_floating_ip
        attribute :idle_timeout_in_minutes
        attribute :load_distribution

        def self.parse(load_balancing_rule)
          load_balancing_rule_prop = load_balancing_rule['properties']
          hash = {}
          hash['id'] = load_balancing_rule['id']
          hash['name'] = load_balancing_rule['name']
          unless load_balancing_rule_prop['frontendIPConfiguration'].nil?
            hash['frontend_ip_configuration_id'] = load_balancing_rule_prop['frontendIPConfiguration']['id']
          end
          unless load_balancing_rule_prop['backendAddressPool'].nil?
            hash['backend_address_pool_id'] = load_balancing_rule_prop['backendAddressPool']['id']
          end

          hash['protocol'] = load_balancing_rule_prop['protocol']
          hash['frontend_port'] = load_balancing_rule_prop['frontendPort']
          hash['backend_port'] = load_balancing_rule_prop['backendPort']
          hash['probe_id'] = load_balancing_rule_prop['probe']['id'] unless load_balancing_rule_prop['probe'].nil?
          hash['enable_floating_ip'] = load_balancing_rule_prop['enableFloatingIP']
          hash['idle_timeout_in_minutes'] = load_balancing_rule_prop['idleTimeoutInMinutes']
          hash['load_distribution'] = load_balancing_rule_prop['loadDistribution']
          hash
        end
      end
    end
  end
end
