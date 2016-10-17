module Fog
  module TrafficManager
    class AzureRM
      # Real class for TrafficManager Request
      class Real
        def delete_traffic_manager_profile(resource_group, name)
          msg = "Deleting Traffic Manager Profile: #{name}."
          Fog::Logger.debug msg
          begin
            @traffic_mgmt_client.profiles.delete(resource_group, name)
            true
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end
      # Mock class for TrafficManager Request
      class Mock
        def delete_traffic_manager_profile(resource_group, name)
          Fog::Logger.debug "Traffic Manager Profile #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
