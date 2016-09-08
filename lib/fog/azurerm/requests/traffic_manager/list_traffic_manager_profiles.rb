module Fog
  module TrafficManager
    class AzureRM
      # Real class for TrafficManager Request
      class Real
        def list_traffic_manager_profiles(resource_group)
          msg = "Listing Traffic Manager Profiles in Resource Group: #{resource_group}."
          Fog::Logger.debug msg
          begin
            profiles = @traffic_mgmt_client.profiles.list_all_in_resource_group(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Traffic Manager Profiles listed successfully in Resource Group: #{resource_group}"
          profiles.value
        end
      end

      # Mock class for TrafficManager Request
      class Mock
        def list_traffic_manager_profiles(*)
          profiles = [
            {
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
          ]
          profiles_mapper = Azure::ARM::TrafficManager::Models::ProfileListResult.mapper
          @traffic_mgmt_client.deserialize(profiles_mapper, profiles, 'result.body')
        end
      end
    end
  end
end
