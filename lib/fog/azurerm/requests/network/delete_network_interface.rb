module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_network_interface(resource_group, name)
          msg = "Deleting NetworkInterface #{name} from Resource Group #{resource_group}"
          Fog::Logger.debug
          begin
            @network_client.network_interfaces.delete(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "NetworkInterface #{name} Deleted Successfully."
          true
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_network_interface(resource_group, name)
          Fog::Logger.debug "Network Interface #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
