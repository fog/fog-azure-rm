module ApiStub
  module Requests
    module Network
      # Mock class for Express Route Circuit Peering Requests
      class ExpressRouteCircuitPeering
        def self.create_express_route_circuit_peering_response
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
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::ExpressRouteCircuitPeering.deserialize_object(JSON.load(body))
          result
        end

        def self.list_express_route_circuit_peering_response
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
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.delete_express_route_circuit_peering_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
