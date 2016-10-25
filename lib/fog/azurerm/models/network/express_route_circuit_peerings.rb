module Fog
  module Network
    class AzureRM
      # ExpressRouteCircuitPeering collection class for Network Service
      class ExpressRouteCircuitPeerings < Fog::Collection
        model ExpressRouteCircuitPeering
        attribute :resource_group
        attribute :circuit_name

        def all
          requires :resource_group, :circuit_name
          circuit_peerings = []
          service.list_express_route_circuit_peerings(resource_group, circuit_name).each do |circuit_peering|
            circuit_peerings << ExpressRouteCircuitPeering.parse(circuit_peering)
          end
          load(circuit_peerings)
        end

        def get(resource_group_name, peering_name, circuit_name)
          circuit_peering = service.get_express_route_circuit_peering(resource_group_name, peering_name, circuit_name)
          express_route_circuit_peering = ExpressRouteCircuitPeering.new(service: service)
          express_route_circuit_peering.merge_attributes(ExpressRouteCircuitPeering.parse(circuit_peering))
        end
      end
    end
  end
end
