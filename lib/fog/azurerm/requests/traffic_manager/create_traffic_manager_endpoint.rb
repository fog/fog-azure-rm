module Fog
  module TrafficManager
    class AzureRM
      # Real class for TrafficManager Request
      class Real
        def create_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type, target_resource_id, target, weight, priority, endpoint_location, min_child_endpoints)
          log_creating = "Creating Traffic Manager Endpoint: #{name}."
          Fog::Logger.debug log_creating
          endpoint_parameters = get_endpoint_parameters(target_resource_id, target, weight, priority, endpoint_location, min_child_endpoints)
          begin
            traffic_manager_endpoint = @traffic_mgmt_client.endpoints.create_or_update(resource_group, traffic_manager_profile_name, type, name, endpoint_parameters)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, log_creating)
          end
          traffic_manager_endpoint
        end

        private

        def get_endpoint_parameters(target_resource_id, target, weight, priority, endpoint_location, min_child_endpoints)
          endpoint = Azure::ARM::TrafficManager::Models::Endpoint.new
          endpoint.min_child_endpoints = min_child_endpoints
          endpoint.target_resource_id = target_resource_id
          endpoint.endpoint_location = endpoint_location
          endpoint.priority = priority
          endpoint.target = target
          endpoint.weight = weight
          endpoint
        end
      end

      # Mock class for TrafficManager Request
      class Mock
        def create_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type, target_resource_id, target, weight, priority, endpoint_location, min_child_endpoints)
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
