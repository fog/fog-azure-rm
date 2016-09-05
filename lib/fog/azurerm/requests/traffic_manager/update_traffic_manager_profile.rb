module Fog
  module TrafficManager
    class AzureRM
      # This class provides the actual implementation for service call.
      class Real
        def update_traffic_manager_profile(resource_group, name, traffic_routing_method, relative_name, ttl, protocol, port, path)
          msg = "Updating Traffic Manager Profile #{name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg

          profile_obj = get_profile_object(traffic_routing_method, relative_name, ttl, protocol, port, path)
          begin
            traffic_manager_profile = @traffic_mgmt_client.profiles.create_or_update(resource_group, name, profile_obj)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Traffic Manager Profile #{name} Updated Successfully!"
          traffic_manager_profile
        end
      end

      # Mock class for Update Traffic Manager Profile Request
      class Mock
        def update_traffic_manager_profile(*)
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