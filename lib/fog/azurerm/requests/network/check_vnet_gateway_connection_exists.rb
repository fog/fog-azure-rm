module Fog
  module Network
    class AzureRM
      # Mock class for Network Request
      class Real
        def check_vnet_gateway_connection_exists(resource_group_name, gateway_connection_name)
          msg = "Checking Virtual Network Gateway Connection #{gateway_connection_name}"
          Fog::Logger.debug msg
          begin
            @network_client.virtual_network_gateway_connections.get(resource_group_name, gateway_connection_name)
            Fog::Logger.debug "Virtual Network Gateway Connection #{gateway_connection_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if resource_not_found?(e)
              Fog::Logger.debug "Virtual Network Gateway Connection #{gateway_connection_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def check_vnet_gateway_connection_exists(*)
          true
        end
      end
    end
  end
end
