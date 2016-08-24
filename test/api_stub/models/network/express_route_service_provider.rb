module ApiStub
  module Models
    module Network
      # Mock class for Express Route Service Provider Model
      class ExpressRouteServiceProvider
        def self.list_express_route_service_provider_response
          peering = '[
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
            ]'
          JSON.parse(peering)
        end
      end
    end
  end
end
