module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_virtual_network(resource_group, name)
          msg = "Deleting Virtual Network: #{name}"
          Fog::Logger.debug msg
          begin
            @network_client.virtual_networks.delete(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Network #{name} deleted successfully."
          true
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_virtual_network(resource_group, name)
          Fog::Logger.debug "Virtual Network #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
