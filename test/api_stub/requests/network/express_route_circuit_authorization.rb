module ApiStub
  module Requests
    module Network
      # Mock class for Express Route Circuit Authorization Requests
      class ExpressRouteCircuitAuthorization
        def self.create_express_route_circuit_authorization_response(network_client)
          authorization = '{
            "name": "MicrosoftAuthorization",
            "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/authorizations/{authorizationName}",
            "properties": {
              "authorizationKey" : "authorization-key",
              "authorizationUseStatus" : "Available"
            }
          }'
          circuit_auth_mapper = Azure::ARM::Network::Models::ExpressRouteCircuitAuthorization.mapper
          network_client.deserialize(circuit_auth_mapper, JSON.load(authorization), 'result.body')
        end

        def self.auth_hash
          {
            resource_group: 'rg-name',
            name: 'auth-unique-name',
            circuit_name: 'circuit-name',
            authorization_status: 'Available',
            authorization_name: 'authorization-name'
          }
        end
      end
    end
  end
end
