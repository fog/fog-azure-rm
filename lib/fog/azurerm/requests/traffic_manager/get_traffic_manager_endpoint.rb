module Fog
  module TrafficManager
    class AzureRM
      # Real class for TrafficManager Request
      class Real
        def get_traffic_manager_end_point(resource_group, traffic_manager_profile_name, traffic_manager_end_point, type)
          msg = "Getting Traffic Manager Endpoint: #{traffic_manager_end_point} in Profile: #{traffic_manager_profile_name}."
          Fog::Logger.debug msg
          begin
            endpoint = @traffic_mgmt_client.endpoints.get(resource_group, traffic_manager_profile_name, type, traffic_manager_end_point)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Traffic Manager Endpoint fetched successfully in Resource Group: #{resource_group}"
          endpoint
        end
      end

      # Mock class for Network Request
      class Mock
        def get_traffic_manager_end_point(*)
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
