require 'fog/core/collection'
require 'fog/azurerm/models/network/express_route_circuit_authorization'

module Fog
  module Network
    class AzureRM
      # ExpressRouteCircuitAuthorization collection class for Network Service
      class ExpressRouteCircuitAuthorizations < Fog::Collection
        model ExpressRouteCircuitAuthorization
        attribute :resource_group
        attribute :circuit_name

        def all
          requires :resource_group, :circuit_name
          circuit_authorizations = service.list_express_route_circuit_authorizations(resource_group, circuit_name).map { |circuit_authorization| ExpressRouteCircuitAuthorization.parse(circuit_authorization) }
          load(circuit_authorizations)
        end

        def get(resource_group_name, circuit_name, authorization_name)
          circuit_authorization = service.get_express_route_circuit_authorization(resource_group_name, circuit_name, authorization_name)
          express_route_circuit_authorization = ExpressRouteCircuitAuthorization.new(service: service)
          express_route_circuit_authorization.merge_attributes(ExpressRouteCircuitAuthorization.parse(circuit_authorization))
        end
      end
    end
  end
end
