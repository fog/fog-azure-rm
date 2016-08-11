module ApiStub
  module Requests
    module Network
      # Mock class for Express Route Service Provider Requests
      class ExpressRouteServiceProvider
        def self.list_express_route_service_providers_response
          body = '{
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
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::ExpressRouteServiceProviderListResult.deserialize_object(JSON.load(body))
          result
        end
      end
    end
  end
end
