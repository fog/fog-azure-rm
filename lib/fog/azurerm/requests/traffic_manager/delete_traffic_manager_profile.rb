module Fog
  module TrafficManager
    class AzureRM
      # Real class for TrafficManager Request
      class Real
        def delete_traffic_manager_profile(resource_group, name)
          log_delete = "Deleting Traffic Manager Profile: #{name}."
          Fog::Logger.debug log_delete
          begin
            @traffic_mgmt_client.profiles.delete(resource_group, name)
            true
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, log_delete)
          end
        end
      end
      # Mock class for TrafficManager Request
      class Mock
        def delete_subnet(resource_group, name)
          Fog::Logger.debug "Traffic Manager Profile #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
