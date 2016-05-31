module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def get_traffic_manager_profile(resource_group, traffic_manager_profile_name)
          Fog::Logger.debug "Getting Traffic Manager Profile: #{traffic_manager_profile_name} in Resource Group: #{resource_group}..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}?api-version=2015-04-28-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
            Fog::Logger.debug 'Traffic Manager Profile listed successfully.'
            JSON.parse(response)
          rescue => e
            Fog::Logger.warning "Exception getting Traffic Manager Profile: #{traffic_manager_profile_name} in resource group: #{resource_group}"
            error_msg = JSON.parse(e.response)['message']
            msg = "Exception getting Traffic Manager Profile: #{traffic_manager_profile_name} in resource group: #{resource_group}. #{error_msg}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def get_traffic_manager_profile(resource_group, traffic_manager_profile_name)
          {
            location: 'global',
            tags: {},
            id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}",
            name: traffic_manager_profile_name,
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
              endpoints: [{
                id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}/azureEndpoints/endpoint-name1",
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
                id: "/subscriptions/####/resourceGroups/resource_group/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}/externalEndpoints/endpoint-name2",
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
                id: "/subscriptions/####/resourceGroups/#{resource_group}/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}/nestedEndpoints/endpoint-name3",
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
              }]
            }
          }
        end
      end
    end
  end
end
