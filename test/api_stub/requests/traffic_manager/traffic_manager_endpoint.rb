module ApiStub
  module Requests
    module TrafficManager
      # Mock class for raffic Manager End Point Requests
      class TrafficManagerEndPoint
        def self.create_traffic_manager_endpoint_response(traffic_manager_client)
          body = '{
            "id": "/subscriptions/######/resourceGroups/fog-test-rg/providers/Microsoft.Network/trafficManagerProfiles/fog-test-profile/externalEndpoints/fog-test-end-point?api-version=2015-11-01",
            "name": "fog-test-end-point",
            "type": "Microsoft.Network/trafficManagerProfiles/externalEndpoints",
            "properties": {
              "endpointStatus": "Enabled",
              "endpointMonitorStatus": "Online",
              "target": "test.com",
              "weight": 10,
              "priority": 5,
              "endpointLocation": "northeurope"
            }
          }'
          endpoint_mapper = Azure::ARM::TrafficManager::Models::Endpoint.mapper
          traffic_manager_client.deserialize(endpoint_mapper, JSON.load(body), 'result.body')
        end
      end
    end
  end
end
