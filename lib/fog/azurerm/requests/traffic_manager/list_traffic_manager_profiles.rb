module Fog
  module TrafficManager
    class AzureRM
      # Real class for TrafficManager Request
      class Real
        def list_traffic_manager_profiles(resource_group)
          log_listing = "Listing Traffic Manager Profiles in Resource Group: #{resource_group}."
          Fog::Logger.debug log_listing
          begin
            profiles = @traffic_mgmt_client.profiles.list_all_in_resource_group(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, log_listing)
          end
          Fog::Logger.debug "Traffic Manager Profiles listed successfully in Resource Group: #{resource_group}"
          profiles.value
        end
      end

      # Mock class for TrafficManager Request
      class Mock
        def list_traffic_manager_profiles(resource_group)
          [
            {
              location: 'global',
              tags: {},
              id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/testprofile",
              name: 'testprofile',
              type: 'Microsoft.Network/trafficManagerProfiles',
              properties: {
                profileStatus: 'Enabled',
                trafficRoutingMethod: 'Performance',
                dnsConfig: {
                  relativeName: 'myapp',
                  fqdn: 'myapp.trafficmanager.net',
                  ttl: 30
                },
                monitorConfig: {
                  profileMonitorStatus: 'Online',
                  protocol: 'http',
                  port: 80,
                  path: '/monitorpage.aspx'
                },
                endpoints: [
                  {
                    id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/testprofile/azureEndpoints/endpoint-name1",
                    name: 'endpoint-name1',
                    type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints',
                    properties: {
                      endpointStatus: 'Enabled',
                      endpointMonitorStatus: 'Online',
                      targetResourceId: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network",
                      target: 'myapp.azurewebsites.net',
                      weight: 10,
                      priority: 3,
                      endpointLocation: 'centralus'
                    }
                  },
                  {
                    id: '/subscriptions/####/resourceGroups/resource_group/Microsoft.Network/trafficManagerProfiles/testprofile/externalEndpoints/endpoint-name2',
                    name: 'endpoint-name2',
                    type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints',
                    properties: {
                      endpointStatus: 'Enabled',
                      endpointMonitorStatus: 'Online',
                      target: 'myendpoint.contoso.com',
                      weight: 10,
                      priority: 5,
                      endpointLocation: 'northeurope'
                    }
                  },
                  {
                    id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/testprofile/nestedEndpoints/endpoint-name3",
                    name: 'endpoint-name3',
                    type: 'Microsoft.Network/trafficManagerProfiles/nestedEndpoints',
                    properties: {
                      endpointStatus: 'Enabled',
                      endpointMonitorStatus: 'Online',
                      targetResourceId: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network",
                      weight: 10,
                      priority: 1,
                      endpointLocation: 'westeurope',
                      minChildEndpoints: 1
                    }
                  }
                ]
              }
            }
          ]
        end
      end
    end
  end
end
