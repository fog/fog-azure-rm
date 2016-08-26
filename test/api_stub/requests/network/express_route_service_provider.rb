module ApiStub
  module Requests
    module Network
      # Mock class for Express Route Service Provider Requests
      class ExpressRouteServiceProvider
        def self.list_express_route_service_providers_response(network_client)
          service_provider = '{
            "value": [
              {
                "name": "<providername>",
                "peeringLocations": [
                  "location1",
                  "location2"
                ],
                "bandwidthsOffered": [
                  {
                    "offerName": "100Mbps",
                    "valueInMbps": 100
                  }
                ]
              }
            ]
          }'
          express_route_servcie_provider_mapper = Azure::ARM::Network::Models::ExpressRouteServiceProviderListResult.mapper
          network_client.deserialize(express_route_servcie_provider_mapper, JSON.load(service_provider), 'result.body').value
        end
      end
    end
  end
end
