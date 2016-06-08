module ApiStub
  module Models
    module Network
      # Mock class for Traffic Manager Profile Model
      class TrafficManagerProfile
        def self.traffic_manager_profile_response
          profile = '{
            "location": "global",
            "tags": {},
            "id": "/subscriptions/####/resourceGroups/fog-test-rg/Microsoft.Network/trafficManagerProfiles/fog-test-profile",
            "name": "fog-test-profile",
            "type": "Microsoft.Network/trafficManagerProfiles",
            "properties": {
              "profileStatus": "Enabled",
              "trafficRoutingMethod": "Performance",
              "dnsConfig": {
                "relativeName": "myapp",
                "fqdn": "myapp.trafficmanager.net",
                "ttl": 30
              },
              "monitorConfig": {
                "profileMonitorStatus": "Online",
                "protocol": "http",
                "port": 80,
                "path": "/monitorpage.aspx"
              },

              "endpoints": [{
                "id": "/subscriptions/####/resourceGroups/fog-test-rg/Microsoft.Network/trafficManagerProfiles/fog-test-profile/azureEndpoints/endpoint-name1",
                "name": "endpoint-name1",
                "type": "Microsoft.Network/trafficManagerProfiles/azureEndpoints",
                "properties": {
                  "endpointStatus": "Enabled",
                  "endpointMonitorStatus": "Online",
                  "targetResourceId": "{resource ID of target resource in Azure}",
                  "target": "myapp.azurewebsites.net",
                  "weight": 10,
                  "priority": 3,
                  "endpointLocation": "centralus"
                }
              }, {
                "id": "/subscriptions/####/resourceGroups/fog-test-rg/Microsoft.Network/trafficManagerProfiles/fog-test-profile/externalEndpoints/endpoint-name2",
                "name": "endpoint-name2",
                "type": "Microsoft.Network/trafficManagerProfiles/externalEndpoints",
                "properties": {
                  "endpointStatus": "Enabled",
                  "endpointMonitorStatus": "Online",
                  "target": "myendpoint.contoso.com",
                  "weight": 10,
                  "priority": 5,
                  "endpointLocation": "northeurope"
                }
              }, {
                "id": "/subscriptions/####/resourceGroups/fog-test-rg/Microsoft.Network/trafficManagerProfiles/fog-test-profile/nestedEndpoints/endpoint-name3",
                "name": "endpoint-name3",
                "type": "Microsoft.Network/trafficManagerProfiles/nestedEndpoints",
                "properties": {
                  "endpointStatus": "Enabled",
                  "endpointMonitorStatus": "Online",
                  "targetResourceId": "####",
                  "weight": 10,
                  "priority": 1,
                  "endpointLocation": "westeurope",
                  "minChildEndpoints": 1
                }
              }]
            }
          }'
          JSON.parse(profile)
        end
      end
    end
  end
end
