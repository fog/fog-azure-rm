module ApiStub
  module Models
    module Network
      # Mock class for Express Route Circuit Peering Model
      class ExpressRouteCircuitPeering
        def self.create_express_route_circuit_peering_response
        peering = '{
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
          JSON.parse(peering)
        end
      end
    end
  end
end
