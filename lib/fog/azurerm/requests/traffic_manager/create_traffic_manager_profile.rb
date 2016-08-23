module Fog
  module TrafficManager
    class AzureRM
      # This class provides the actual implementation for service call.
      class Real
        def create_traffic_manager_profile(resource_group, name, traffic_routing_method, relative_name, ttl, protocol,
                                           port, path)
          log_message = "Creating Traffic Manager Profile: #{name}."
          Fog::Logger.debug log_message

          traffic_manager_profile_parameters = get_traffic_manager_profile_properties(traffic_routing_method, relative_name, ttl, protocol,
                                                                                      port, path)
          begin
            resource_group = @traffic_manager_mgmt_client.traffic_manager_profiles.create_or_update(resource_group, name, traffic_manager_profile_parameters, custom_headers = nil)
            Fog::Logger.debug "Traffic Manager Profile: #{name} created successfully."
            resource_group
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end


      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_traffic_manager_profile(resource_group, name, traffic_routing_method, relative_name, ttl, protocol,
                                           port, path)
          {
              location: 'global',
              tags: {},
              id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/#{name}",
              name: name,
              type: 'Microsoft.Network/trafficManagerProfiles',
              properties: {
                  profileStatus: 'Enabled',
                  trafficRoutingMethod: traffic_routing_method,
                  dnsConfig: {
                      relativeName: relative_name,
                      fqdn: 'myapp.trafficmanager.net',
                      ttl: ttl
                  },
                  monitorConfig: {
                      profileMonitorStatus: 'Online',
                      protocol: protocol,
                      port: port,
                      path: path
                  },

                  endpoints: [{
                                  id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/#{name}/azureEndpoints/endpoint-name1",
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
                              }, {
                                  id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/#{name}/externalEndpoints/endpoint-name2",
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
                              }, {
                                  id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/#{name}/nestedEndpoints/endpoint-name3",
                                  name: 'endpoint-name3',
                                  type: 'Microsoft.Network/trafficManagerProfiles/nestedEndpoints',
                                  properties: {
                                      endpointStatus: 'Enabled',
                                      endpointMonitorStatus: 'Online',
                                      targetResourceId: '####',
                                      weight: 10,
                                      priority: 1,
                                      endpointLocation: 'westeurope',
                                      minChildEndpoints: 1
                                  }
                              }]
              }
          }
        end
      end
    end
  end
end
