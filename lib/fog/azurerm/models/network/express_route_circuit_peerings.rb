require 'fog/core/collection'
require 'fog/azurerm/models/network/express_route_circuit_peering'

module Fog
  module Network
    class AzureRM
      # ExpressRouteCircuitPeering collection class for Network Service
      class ExpressRouteCircuitPeerings < Fog::Collection
        model Fog::Network::AzureRM::ExpressRouteCircuitPeering
        attribute :resource_group
        attribute :circuit_name

        def all
          requires :resource_group
          requires :circuit_name
          circuit_peerings = []
          service.list_express_route_circuit_peerings(resource_group, circuit_name).each do |circuit_peering|
            circuit_peerings << Fog::Network::AzureRM::ExpressRouteCircuitPeering.parse(circuit_peering)
          end
          load(circuit_peerings)
        end

        def get(resource_group_name, peering_name, circuit_name)
          circuit_peering = service.get_express_route_circuit_peering(resource_group_name, peering_name, circuit_name)
          express_route_circuit_peering = Fog::Network::AzureRM::ExpressRouteCircuitPeering.new(service: service)
          express_route_circuit_peering.merge_attributes(Fog::Network::AzureRM::ExpressRouteCircuitPeering.parse(circuit_peering))
        end
      end
    end
  end
end
