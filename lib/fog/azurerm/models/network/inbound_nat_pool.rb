module Fog
  module Network
    class AzureRM
      # InboundNatPool model for Network Service
      class InboundNatPool < Fog::Model
        identity :name
        attribute :id
        attribute :protocol
        attribute :frontend_port_range_start
        attribute :frontend_port_range_end
        attribute :backend_port

        def self.parse(inbound_nat_pool)
          inbound_nat_pool_prop = inbound_nat_pool['properties']
          hash = {}
          hash['id'] = inbound_nat_pool['id']
          hash['name'] = inbound_nat_pool['name']
          hash['protocol'] = inbound_nat_pool_prop['protocol']
          hash['frontend_port_range_start'] = inbound_nat_pool_prop['frontendPortRangeStart']
          hash['frontend_port_range_end'] = inbound_nat_pool_prop['frontendPortRangeEnd']
          hash['backend_port'] = inbound_nat_pool_prop['backendPort']
          hash
        end
      end
    end
  end
end
