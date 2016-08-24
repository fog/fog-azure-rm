module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_traffic_manager_profile(resource_group, name, traffic_routing_method, relative_name, ttl, protocol,
                                           port, path)
          Fog::Logger.debug "Creating Traffic Manager Profile: #{name}."
          traffic_manager_profile_parameters = get_traffic_manager_profile_properties(traffic_routing_method, relative_name, ttl, protocol,
                                                                                      port, path)
          begin
            resource_group = @network_client.traffic_manager_profiles.create_or_update(resource_group, name, traffic_manager_profile_parameters, custom_headers = nil)
            Fog::Logger.debug "Traffic Manager Profile: #{name} created successfully."
            resource_group
          rescue  MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
#========================================
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/trafficManagerProfiles/#{name}?api-version=2015-04-28-preview"
          payload = serialize_profile_request(traffic_routing_method, relative_name, ttl, protocol, port, path)
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.put(
              resource_url,
              payload.to_json,
              accept: :json,
              content_type: :json,
              authorization: token
            )
            Fog::Logger.debug "Traffic Manager Profile: #{name} created successfully."
            JSON.parse(response)
          rescue => e
            Fog::Logger.warning "Exception creating Traffic Manager Profile: #{name} in resource group #{resource_group}"
            error_msg = JSON.parse(e.response)['message']
            msg = "Exception creating Traffic Manager Profile: #{name} in resource group #{resource_group}. #{error_msg}"
            raise msg
          end
        end

        private

        def get_traffic_manager_profile_properties(traffic_routing_method, relative_name, ttl, protocol, port, path)

          traffic_manager_profile_properties = Azure::ARM::TrafficManager::Models::Profile.new
          traffic_manager_profile_properties.profile_status = 'Enabled'
          traffic_manager_profile_properties.traffic_routing_method = traffic_routing_method

          traffic_manager_dns_config = Azure::ARM::TrafficManager::Models::DnsConfig.new
          traffic_manager_dns_config.relative_name = relative_name
          traffic_manager_dns_config.ttl = ttl
          traffic_manager_dns_config.fqdn = relative_name + #todo
          traffic_manager_profile_properties.dns_config = traffic_manager_dns_config

          traffic_manager_monitor_config = Azure::ARM::TrafficManager::Models::MonitorConfig.new
          traffic_manager_monitor_config.path = path
          traffic_manager_monitor_config.protocol = protocol
          traffic_manager_monitor_config.port = port
          traffic_manager_monitor_config.profile_monitor_status = #todo
          traffic_manager_profile_properties.monitor_config = traffic_manager_monitor_config

          traffic_manager_endpoint = Azure::ARM::TrafficManager::Models::Endpoint.new
          traffic_manager_endpoint.id = # todo
          traffic_manager_endpoint.name = # todo
          traffic_manager_endpoint.type = # todo
          traffic_manager_endpoint.target_resource_id = # todo
          traffic_manager_endpoint.target = #todo
          traffic_manager_endpoint.endpoint_status = #todo
          traffic_manager_endpoint.weight = #todo
          traffic_manager_endpoint.priority = #todo
          traffic_manager_endpoint.endpoint_location = #todo
          traffic_manager_endpoint.endpoint_monitor_status = #todo
          traffic_manager_endpoint.min_child_endpoints = #todo
          traffic_manager_profile_properties.endpoints = traffic_manager_endpoint



          traffic_manager_profile_properties
        end

        def serialize_profile_request(traffic_routing_method, relative_name, ttl, protocol, port, path)
          dns_config = {}
          dns_config['relativeName'] = relative_name
          dns_config['ttl'] = ttl

          monitor_config = {}
          monitor_config['protocol'] = protocol
          monitor_config['port'] = port
          monitor_config['path'] = path

          properties = {}
          properties['trafficRoutingMethod'] = traffic_routing_method
          properties['dnsConfig'] = dns_config
          properties['monitorConfig'] = monitor_config
          properties['endpoints'] = []

          payload = {}
          payload['location'] = 'global'
          payload['tags'] = {}
          payload['properties'] = properties

          payload
        end
      end

      # Mock class for Network Request
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
