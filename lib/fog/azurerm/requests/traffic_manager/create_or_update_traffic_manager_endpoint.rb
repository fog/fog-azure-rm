module Fog
  module TrafficManager
    class AzureRM
      # Real class for Traffic Manager Request
      class Real
        def create_or_update_traffic_manager_endpoint(endpoint_hash)
          msg = "Creating Traffic Manager Endpoint: #{endpoint_hash[:name]}."
          Fog::Logger.debug msg
          endpoint_parameters = get_endpoint_object(endpoint_hash[:target_resource_id], endpoint_hash[:target], endpoint_hash[:weight], endpoint_hash[:priority], endpoint_hash[:endpoint_location], endpoint_hash[:min_child_endpoints])
          begin
            traffic_manager_endpoint = @traffic_mgmt_client.endpoints.create_or_update(endpoint_hash[:resource_group], endpoint_hash[:traffic_manager_profile_name],
                                                                                       endpoint_hash[:type], endpoint_hash[:name], endpoint_parameters)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Traffic Manager Endpoint: #{endpoint_hash[:name]} created successfully."
          traffic_manager_endpoint
        end

        private

        def get_endpoint_object(target_resource_id, target, weight, priority, endpoint_location, min_child_endpoints)
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
        def create_or_update_traffic_manager_endpoint(*)
          endpoint = {
            'name' => '{endpoint-name}',
            'type' => 'Microsoft.Network/trafficManagerProfiles/externalEndpoints',
            'properties' => {
              'target' => 'myendpoint.contoso.com',
              'endpointStatus' => 'Enabled',
              'weight' => 10,
              'priority' => 5,
              'endpointLocation' => 'northeurope'
            }
          }
          endpoint_mapper = Azure::ARM::TrafficManager::Models::Endpoint.mapper
          @traffic_mgmt_client.deserialize(endpoint_mapper, endpoint, 'result.body')
        end
      end
    end
  end
end
