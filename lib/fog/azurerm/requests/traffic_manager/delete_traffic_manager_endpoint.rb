module Fog
  module TrafficManager
    class AzureRM
      # Real class for TrafficManager Request
      class Real
        def delete_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type)
          log_delete_endpoint = "Deleting Traffic Manager Endpoint: #{name}."
          Fog::Logger.debug log_delete_endpoint
          begin
            @traffic_mgmt_client.endpoints.delete(resource_group, traffic_manager_profile_name, type, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, log_delete_endpoint)
          end
          Fog::Logger.debug "Traffic Manager Endpoint: #{name} deleted successfully."
          true
        end
      end

      # Mock class for TrafficManager Request
      class Mock
        def delete_traffic_manager_endpoint(resource_group, name, _traffic_manager_profile_name, _type)
          Fog::Logger.debug "Traffic Manager End Point #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
