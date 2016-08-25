module Fog
  module TrafficManager
    class AzureRM
      # This class provides the actual implementation for service call.
      class Real
        def create_traffic_manager_profile(resource_group, name, traffic_routing_method, relative_name, ttl, protocol, port, path)
          msg = "Creating Traffic Manager Profile: #{name}."
          Fog::Logger.debug msg
          profile_parameters = get_profile_object(traffic_routing_method, relative_name, ttl, protocol, port, path)
          begin
            traffic_manager_profile = @traffic_mgmt_client.profiles.create_or_update(resource_group, name, profile_parameters)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Traffic Manager Profile: #{name} created successfully."
          traffic_manager_profile
        end

        private

        def get_profile_object(traffic_routing_method, relative_name, ttl, protocol, port, path)
          traffic_manager_profile = Azure::ARM::TrafficManager::Models::Profile.new
          traffic_manager_profile.traffic_routing_method = traffic_routing_method
          traffic_manager_profile.location = 'global'

          traffic_manager_profile.dns_config = get_traffic_manager_dns_config(relative_name, ttl)
          traffic_manager_profile.monitor_config = get_traffic_manager_monitor_config(protocol, port, path)
          traffic_manager_profile
        end

        def get_traffic_manager_dns_config(relative_name, ttl)
          traffic_manager_dns_config = Azure::ARM::TrafficManager::Models::DnsConfig.new
          traffic_manager_dns_config.relative_name = relative_name
          traffic_manager_dns_config.ttl = ttl
          traffic_manager_dns_config
        end

        def get_traffic_manager_monitor_config(protocol, port, path)
          traffic_manager_monitor_config = Azure::ARM::TrafficManager::Models::MonitorConfig.new
          traffic_manager_monitor_config.path = path
          traffic_manager_monitor_config.protocol = protocol
          traffic_manager_monitor_config.port = port
          traffic_manager_monitor_config
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_traffic_manager_profile(*)
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
