module Fog
  module Network
    class AzureRM
      # ExpressRouteCircuit collection class for Network Service
      class ExpressRouteCircuits < Fog::Collection
        model ExpressRouteCircuit
        attribute :resource_group

        def all
          requires :resource_group
          express_route_circuits = []
          service.list_express_route_circuits(resource_group).each do |circuit|
            express_route_circuits << ExpressRouteCircuit.parse(circuit)
          end
          load(express_route_circuits)
        end

        def get(resource_group_name, name)
          circuit = service.get_express_route_circuit(resource_group_name, name)
          express_route_circuit = ExpressRouteCircuit.new(service: service)
          express_route_circuit.merge_attributes(ExpressRouteCircuit.parse(circuit))
        end
      end
    end
  end
end
