module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_virtual_network_gateway(resource_group_name, virtual_network_gateway_name)
          msg = "Deleting Virtual Network Gateway #{virtual_network_gateway_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            @network_client.virtual_network_gateways.delete(resource_group_name, virtual_network_gateway_name).value!
            Fog::Logger.debug "Virtual Network Gateway #{virtual_network_gateway_name} Deleted Successfully."
            true
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_virtual_network_gateway(resource_group_name, virtual_network_gateway_name)
          Fog::Logger.debug "Virtual Network Gateway #{virtual_network_gateway_name} from Resource group #{resource_group_name} deleted successfully."
          true
        end
      end
    end
  end
end
