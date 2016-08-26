module Fog
  module TrafficManager
    class AzureRM
      # Real class for TrafficManager Request
      class Real
        def get_traffic_manager_profile(resource_group, traffic_manager_profile_name)
          msg = "Getting Traffic Manager Profile: #{traffic_manager_profile_name} in Resource Group: #{resource_group}..."
          Fog::Logger.debug msg
          begin
            profile = @traffic_mgmt_client.profiles.get(resource_group, traffic_manager_profile_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Traffic Manager Profile fetched successfully in Resource Group: #{resource_group}"
          profile
        end
      end

      # Mock class for Network Request
      class Mock
        def get_traffic_manager_profile(*)
          profile = {
            'location' => 'global',
            'tags' => {},
            'properties' => {
              'profileStatus' => 'Enabled',
              'trafficRoutingMethod' => 'Performance',
              'dnsConfig' => {
                'relativeName' => 'myapp',
                'ttl' => 30
              },
              'monitorConfig' => {
                'protocol' => 'http',
                'port' => 80,
                'path' => '/monitorpage.aspx'
              },
              'endpoints' => [
                {
                  'name' => '{endpoint-name}',
                  'type' => 'Microsoft.Network/trafficManagerProfiles/azureEndpoints',
                  'properties' => {
                    'targetResourceId' => '{resource ID of target resource in Azure}',
                    'endpointStatus' => 'Enabled',
                    'weight' => 10,
                    'priority' => 3
                  }
                },
                {
                  'name' => '{endpoint-name}',
                  'type' => 'Microsoft.Network/trafficManagerProfiles/externalEndpoints',
                  'properties' => {
                    'target' => 'myendpoint.contoso.com',
                    'endpointStatus' => 'Enabled',
                    'weight' => 10,
                    'priority' => 5,
                    'endpointLocation' => 'northeurope'
                  }
                },
                {
                  'name' => '{endpoint-name}',
                  'type' => 'Microsoft.Network/trafficManagerProfiles/nestedEndpoints',
                  'properties' => {
                    'targetResourceId' => '{resource ID of child Traffic Manager profile}',
                    'endpointStatus' => 'Enabled',
                    'weight' => 10,
                    'priority' => 1,
                    'endpointLocation' => 'westeurope',
                    'minChildEndpoints' => 1
                  }
                }
              ]
            }
          }
          profile_mapper = Azure::ARM::TrafficManager::Models::Profile.mapper
          @traffic_mgmt_client.deserialize(profile_mapper, profile, 'result.body')
        end
      end
    end
  end
end
