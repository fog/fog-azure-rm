module ApiStub
  module Requests
    module Network
      # Mock class for Express Route Circuit Requests
      class ExpressRouteCircuit
        def self.create_express_route_circuit_response
          body = '{
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
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::ExpressRouteCircuit.deserialize_object(JSON.load(body))
          result
        end

        def self.list_express_route_circuit_response
          body = '{
            "value": [
              {
                "name": "<circuit name>",
                "id": "/subscriptions/{guid}/resourceGroup/{resourceGroupName}/providers/Microsoft.Network/expressRouteCircuits/{circuitName}",
                "etag": " W/\"00000000-0000-0000-0000-000000000000\"",
                "location": "eastus",
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
                  "provisioningState": "Succeeded",
                  "circuitProvisioningState": "Enabled",
                  "serviceProviderProvisioningState": "Provisioned",
                  "serviceProviderProperties": {
                    "serviceProviderName": "serviceProviderName",
                    "peeringLocation": "<peering location",
                    "bandwidthInMbps": 100
                  }
                },
                "serviceKey": "<unique service key for circuit>",
                "serviceProviderNotes": "<notes set only by ServiceProvider>"
              }
            ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::ExpressRouteCircuitListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.delete_express_route_circuit_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end

        def self.peerings
          peerings =
            [
              {
                name: 'AzurePrivatePeering',
                circuit_name: 'Circuit Name',
                resource_group: 'Fog-rg',
                peering_type: 'AzurePrivatePeering',
                peer_asn: 100,
                primary_peer_address_prefix: '192.168.3.0/30',
                secondary_peer_address_prefix: '192.168.4.0/30',
                vlan_id: 200
              }
            ]
          peerings
        end
      end
    end
  end
end
