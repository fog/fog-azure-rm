module ApiStub
  module Requests
    module Network
      # Mock class for Traffic Manager Profile Requests
      class TrafficManagerProfile
        def self.create_traffic_manager_profile_response
          body = '{
            "location": "global",
            "tags": {},
            "id": "/subscriptions/###/resourceGroups/fog-test-rg/Microsoft.Network/trafficManagerProfiles/fog-test-profile",
            "name": "fog-test-profile",
            "type": "Microsoft.Network/trafficManagerProfiles",
            "properties": {
              "profileStatus": "Enabled",
              "trafficRoutingMethod": "Performance",
              "dnsConfig": {
                "relativeName": "fog-test-app",
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
                "id": "{ARM resource ID of this endpoint}",
                "name": "{endpoint-name}",
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
                "id": "{ARM resource ID of this endpoint}",
                "name": "{endpoint-name}",
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
                "id": "{ARM resource ID of this endpoint}",
                "name": "{endpoint-name}",
                "type": "Microsoft.Network/trafficManagerProfiles/nestedEndpoints",
                "properties": {
                  "endpointStatus": "Enabled",
                  "endpointMonitorStatus": "Online",
                  "targetResourceId": "{resource ID of child Traffic Manager profile}",
                  "weight": 10,
                  "priority": 1,
                  "endpointLocation": "westeurope",
                  "minChildEndpoints": 1
                }
              }]
            }
          }'
          body
        end

        def self.list_traffic_manager_profiles_response
          body = '{
            "values": [{
              "location": "global",
              "tags": {},
              "id": "/subscriptions/###/resourceGroups/fog-test-rg/Microsoft.Network/trafficManagerProfiles/fog-test-profile",
              "name": "fog-test-profile",
              "type": "Microsoft.Network/trafficManagerProfiles",
              "properties": {
                "profileStatus": "Enabled",
                "trafficRoutingMethod": "Performance",
                "dnsConfig": {
                  "relativeName": "fog-test-app",
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
                  "id": "{ARM resource ID of this endpoint}",
                  "name": "{endpoint-name}",
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
                  "id": "{ARM resource ID of this endpoint}",
                  "name": "{endpoint-name}",
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
                  "id": "{ARM resource ID of this endpoint}",
                  "name": "{endpoint-name}",
                  "type": "Microsoft.Network/trafficManagerProfiles/nestedEndpoints",
                  "properties": {
                    "endpointStatus": "Enabled",
                    "endpointMonitorStatus": "Online",
                    "targetResourceId": "{resource ID of child Traffic Manager profile}",
                    "weight": 10,
                    "priority": 1,
                    "endpointLocation": "westeurope",
                    "minChildEndpoints": 1
                  }
                }]
              }
            }]
          }'
          body
        end
      end
    end
  end
end
