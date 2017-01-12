module Fog
  module TrafficManager
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_traffic_manager_endpoint_exists(resource_group, traffic_manager_profile_name, traffic_manager_end_point, type)
          msg = "Checking Traffic Manager Endpoint #{traffic_manager_end_point}"
          Fog::Logger.debug msg
          begin
            @traffic_mgmt_client.endpoints.get(resource_group, traffic_manager_profile_name, type, traffic_manager_end_point)
            Fog::Logger.debug "Traffic Manager Endpoint #{traffic_manager_end_point} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['code'] == 'NotFound'
              Fog::Logger.debug "Traffic Manager Endpoint #{traffic_manager_end_point} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_traffic_manager_endpoint_exists(*)
          true
        end
      end
    end
  end
end
