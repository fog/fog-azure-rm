module Fog
  module TrafficManager
    class AzureRM
      # This class provides the actual implementation for service call.
      class Real
        def create_or_update_traffic_manager_profile(profile_hash)
          msg = "Creating Traffic Manager Profile: #{profile_hash[:name]}."
          Fog::Logger.debug msg
          profile_parameters = get_profile_object(profile_hash[:traffic_routing_method],
                                                  profile_hash[:relative_name],
                                                  profile_hash[:ttl],
                                                  profile_hash[:protocol],
                                                  profile_hash[:port],
                                                  profile_hash[:path],
                                                  profile_hash[:endpoints],
                                                  profile_hash[:tags])
          begin
            traffic_manager_profile = @traffic_mgmt_client.profiles.create_or_update(profile_hash[:resource_group],
                                                                                     profile_hash[:name],
                                                                                     profile_parameters)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Traffic Manager Profile: #{profile_hash[:name]} created successfully."
          traffic_manager_profile
        end

        private

        def get_profile_object(traffic_routing_method, relative_name, ttl, protocol, port, path, endpoints, tags)
          traffic_manager_profile = Azure::ARM::TrafficManager::Models::Profile.new
          traffic_manager_profile.traffic_routing_method = traffic_routing_method
          traffic_manager_profile.location = GLOBAL

          traffic_manager_profile.dns_config = get_traffic_manager_dns_config(relative_name, ttl)
          traffic_manager_profile.monitor_config = get_traffic_manager_monitor_config(protocol, port, path)
          traffic_manager_profile.endpoints = get_endpoints(endpoints) unless endpoints.nil?
          traffic_manager_profile.tags = tags
          traffic_manager_profile
        end

        def get_endpoints(endpoints)
          endpoint_objects = []

          endpoints.each do |endpoint|
            endpoint_object = get_endpoint_object(endpoint[:target_resource_id], endpoint[:target], endpoint[:weight], endpoint[:priority], endpoint[:endpoint_location], endpoint[:min_child_endpoints])
            endpoint_object.name = endpoint[:name]
            endpoint_object.type = "#{ENDPOINT_PREFIX}/#{endpoint[:type]}"
            endpoint_objects.push(endpoint_object)
          end
          endpoint_objects
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
        def create_or_update_traffic_manager_profile(*)
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
