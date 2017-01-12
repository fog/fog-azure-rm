module Fog
  module TrafficManager
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_traffic_manager_profile_exists(resource_group, traffic_manager_profile_name)
          msg = "Checking Traffic Manager Profile #{traffic_manager_profile_name}"
          Fog::Logger.debug msg
          begin
            @traffic_mgmt_client.profiles.get(resource_group, traffic_manager_profile_name)
            Fog::Logger.debug "Traffic Manager Profile #{traffic_manager_profile_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Traffic Manager Profile #{traffic_manager_profile_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_traffic_manager_profile_exists(*)
          true
        end
      end
    end
  end
end
