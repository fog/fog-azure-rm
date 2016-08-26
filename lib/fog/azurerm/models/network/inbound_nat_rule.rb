module Fog
  module Network
    class AzureRM
      # InboundNatRule model for Network Service
      class InboundNatRule < Fog::Model
        identity :name
        attribute :id
        attribute :frontend_ip_configuration_id
        attribute :protocol
        attribute :frontend_port
        attribute :backend_port

        def self.parse(inbound_nat_rule)
          hash = {}
          hash['id'] = inbound_nat_rule.id
          hash['name'] = inbound_nat_rule.name
          hash['frontend_ip_configuration_id'] = inbound_nat_rule.frontend_ipconfiguration.id unless inbound_nat_rule.frontend_ipconfiguration.nil?
          hash['protocol'] = inbound_nat_rule.protocol
          hash['frontend_port'] = inbound_nat_rule.frontend_port
          hash['backend_port'] = inbound_nat_rule.backend_port
          hash
        end
      end
    end
  end
end
