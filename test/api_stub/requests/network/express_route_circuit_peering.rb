module ApiStub
  module Requests
    module Network
      # Mock class for Express Route Circuit Peering Requests
      class ExpressRouteCircuitPeering
        def self.create_express_route_circuit_peering_response(network_client)
          body = '{
          "name": "MicrosoftPeering",
          "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
          "properties": {
              "peeringType": "MicrosoftPeering",
              "peerASN": 100,
              "primaryPeerAddressPrefix": "192.168.1.0/30",
              "secondaryPeerAddressPrefix": "192.168.2.0/30",
              "vlanId": 200,
              "microsoftPeeringConfig": {
                "advertisedpublicprefixes": [
                  "11.2.3.4/30",
                  "12.2.3.4/30"
                ],
                "advertisedPublicPrefixState": "NotConfigured ",
                "customerAsn": 200,
                "routingRegistryName": "<name>"
              }
            }
          }'
          express_route_circuit_mapper = Azure::ARM::Network::Models::ExpressRouteCircuitPeering.mapper
          network_client.deserialize(express_route_circuit_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.list_express_route_circuit_peering_response(network_client)
          body = '{
            "value": [
              {
                "name": "MicrosoftPeering",
                "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
                "properties": {
                  "peeringType": "MicrosoftPeering",
                  "peerASN": 100,
                  "primaryPeerAddressPrefix": "192.168.1.0/30",
                  "secondaryPeerAddressPrefix": "192.168.2.0/30",
                  "vlanId": 200,
                  "microsoftPeeringConfig": {
                    "advertisedpublicprefixes": [
                      "11.2.3.4/30",
                      "12.2.3.4/30"
                    ],
                    "advertisedPublicPrefixState": "NotConfigured ",
                    "customerAsn": 200,
                    "routingRegistryName": "<name>"
                  }
                }
              }
            ]
          }'
          express_route_circuit_mapper = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringListResult.mapper
          network_client.deserialize(express_route_circuit_mapper, Fog::JSON.decode(body), 'result.body').value
        end
      end
    end
  end
end
