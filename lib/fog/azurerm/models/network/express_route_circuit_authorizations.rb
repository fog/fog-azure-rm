module Fog
  module Network
    class AzureRM
      # ExpressRouteCircuitAuthorization collection class for Network Service
      class ExpressRouteCircuitAuthorizations < Fog::Collection
        model Fog::Network::AzureRM::ExpressRouteCircuitAuthorization
        attribute :resource_group
        attribute :circuit_name

        def all
          requires :resource_group, :circuit_name
          circuit_authorizations = service.list_express_route_circuit_authorizations(resource_group, circuit_name).map { |circuit_authorization| Fog::Network::AzureRM::ExpressRouteCircuitAuthorization.parse(circuit_authorization) }
          load(circuit_authorizations)
        end

        def get(resource_group_name, circuit_name, authorization_name)
          circuit_authorization = service.get_express_route_circuit_authorization(resource_group_name, circuit_name, authorization_name)
          express_route_circuit_authorization = Fog::Network::AzureRM::ExpressRouteCircuitAuthorization.new(service: service)
          express_route_circuit_authorization.merge_attributes(Fog::Network::AzureRM::ExpressRouteCircuitAuthorization.parse(circuit_authorization))
        end

        def check_express_route_cir_auth_exists?(resource_group_name, circuit_name, authorization_name)
          service.check_express_route_cir_auth_exists?(resource_group_name, circuit_name, authorization_name)
        end
      end
    end
  end
end
