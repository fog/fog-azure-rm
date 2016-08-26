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
          hash = {}
          hash['id'] = load_balancing_rule.id
          hash['name'] = load_balancing_rule.name
          hash['frontend_ip_configuration_id'] = load_balancing_rule.frontend_ipconfiguration.id unless load_balancing_rule.frontend_ipconfiguration.nil?
          hash['backend_address_pool_id'] = load_balancing_rule.backend_address_pool.id unless load_balancing_rule.backend_address_pool.nil?

          hash['protocol'] = load_balancing_rule.protocol
          hash['frontend_port'] = load_balancing_rule.frontend_port
          hash['backend_port'] = load_balancing_rule.backend_port
          hash['probe_id'] = load_balancing_rule.probe.id unless load_balancing_rule.probe.nil?
          hash['enable_floating_ip'] = load_balancing_rule.enable_floating_ip
          hash['idle_timeout_in_minutes'] = load_balancing_rule.idle_timeout_in_minutes
          hash['load_distribution'] = load_balancing_rule.load_distribution
          hash
        end
      end
    end
  end
end
