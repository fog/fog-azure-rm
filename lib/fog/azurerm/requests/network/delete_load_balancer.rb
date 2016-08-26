module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_load_balancer(resource_group, name)
          msg = "Deleting Load_Balancer #{name} from Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            @network_client.load_balancers.delete(resource_group, name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Load_Balancer #{name} Deleted Successfully."
          true
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_load_balancer(_resource_group, _name)
          Fog::Logger.debug "Load_Balancer #{name} Deleted Successfully."
          true
        end
      end
    end
  end
end
