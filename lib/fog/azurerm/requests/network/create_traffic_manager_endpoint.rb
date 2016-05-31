module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type,
                                            target_resource_id, target, weight, priority, endpoint_location,
                                            min_child_endpoints)
          Fog::Logger.debug "Creating Traffic Manager Endpoint: #{name}..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}/#{type}Endpoints/#{name}?api-version=2015-11-01"
          payload = serialize_endpoint_request(name, type, target_resource_id, target, weight, priority, endpoint_location,
                                      min_child_endpoints)
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.put(
              resource_url,
              payload.to_json,
              accept: :json,
              content_type: :json,
              authorization: token
            )
            Fog::Logger.debug "Traffic Manager Endpoint: #{name} created successfully."
            JSON.parse(response)
          rescue => e
            Fog::Logger.warning "Exception creating Traffic Manager Endpoint: #{name} in resource group #{resource_group}"
            error_msg = JSON.parse(e.response)['message']
            msg = "Exception creating Traffic Manager Endpoint: #{name} in resource group #{resource_group}. #{error_msg}"
            raise msg
          end
        end

        private

        def serialize_endpoint_request(name, type, target_resource_id, target, weight, priority, endpoint_location,
                              min_child_endpoints)

          properties = {}
          properties['targetResourceId'] = target_resource_id unless target_resource_id.nil?
          properties['target'] = target unless target.nil?
          properties['weight'] = weight
          properties['priority'] = priority
          properties['endpointLocation'] = endpoint_location unless endpoint_location.nil?
          properties['minChildEndpoints'] = min_child_endpoints unless min_child_endpoints.nil?

          payload = {}
          payload['name'] = name
          payload['type'] = "Microsoft.Network/trafficManagerProfiles/#{type}Endpoints"
          payload['properties'] = properties

          payload
        end
      end

      # Mock class for Network Request
      class Mock
        def create_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type,
                                            target_resource_id, target, weight, priority, endpoint_location,
                                            min_child_endpoints)
          response = {}
          properties = {}

          properties['weight'] = weight
          properties['priority'] = priority
          properties['targetResourceId'] = target_resource_id unless target_resource_id.nil?
          properties['target'] = target unless target.nil?
          properties['endpointLocation'] = endpoint_location unless endpoint_location.nil?
          properties['minChildEndpoints'] = min_child_endpoints unless min_child_endpoints.nil?

          response['id'] = "/subscriptions/######/resourceGroups/#{resource_group}/providers/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}/#{type}Endpoints/#{name}?api-version=2015-11-01"
          response['type'] = "Microsoft.Network/trafficManagerProfiles/#{type}Endpoints"
          response['properties'] = properties

          response
        end
      end
    end
  end
end
