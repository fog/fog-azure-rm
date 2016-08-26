module ApiStub
  module Models
    module Network
      # Mock class for Express Route Circuit Model
      class ExpressRouteCircuit
        def self.create_express_route_circuit_response(network_client)
          circuit = '{
            "name": "<circuit name>",
            "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/testCircuit",
            "location": "<location>",
            "tags": {
              "key1": "value1",
              "key2": "value2"
            },
            "sku": {
              "name": "Standard_MeteredData",
              "tier": "Standard",
              "family": "MeteredData"
            },
            "properties": {
              "serviceProviderProperties": {
                  "serviceProviderName": "serviceProviderName",
                  "peeringLocation": "<peering location>",
                  "bandwidthInMbps": 100
              },
              "peerings": [
                {
                  "name": "AzurePublicPeering",
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}/peerings/{peeringName}",
                  "properties": {
                    "peeringType": "AzurePublicPeering",
                    "peerASN": 100,
                    "PrimaryPeerAddressPrefix": "192.168.1.0/30",
                    "SecondaryPeerAddressPrefix": "192.168.2.0/30",
                    "vlanId": 200
                  }
                }
              ]
            }
          }'
          express_route_circuit_mapper = Azure::ARM::Network::Models::ExpressRouteCircuit.mapper
          network_client.deserialize(express_route_circuit_mapper, JSON.load(circuit), 'result.body')
        end
      end
    end
  end
end
