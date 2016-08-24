module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_network_interface(resource_group, name)
          Fog::Logger.debug "Deleting NetworkInterface #{name} from Resource Group #{resource_group}."
          begin
            @network_client.network_interfaces.delete(resource_group, name)
            Fog::Logger.debug "NetworkInterface #{name} Deleted Successfully."
            true
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, "Deleting NetworkInterface #{name} from Resource Group #{resource_group}")
          end
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
