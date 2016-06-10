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
          inbound_nat_rule_prop = inbound_nat_rule['properties']
          hash = {}
          hash['id'] = inbound_nat_rule['id']
          hash['name'] = inbound_nat_rule['name']
          unless inbound_nat_rule_prop['frontendIPConfiguration'].nil?
            hash['frontend_ip_configuration_id'] = inbound_nat_rule_prop['frontendIPConfiguration']['id']
          end
          hash['protocol'] = inbound_nat_rule_prop['protocol']
          hash['frontend_port'] = inbound_nat_rule_prop['frontendPort']
          hash['backend_port'] = inbound_nat_rule_prop['backendPort']
          hash
        end
      end
    end
  end
end
