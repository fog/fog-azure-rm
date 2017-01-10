module Fog
  module Network
    class AzureRM
      # Mock class for Network Request
      class Real
        def check_vnet_gateway_exists(resource_group_name, network_gateway_name)
          msg = "Checking Virtual Network Gateway #{network_gateway_name}"
          Fog::Logger.debug msg
          begin
            @network_client.virtual_network_gateways.get(resource_group_name, network_gateway_name)
            Fog::Logger.debug "Virtual Network Gateway #{network_gateway_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Virtual Network Gateway #{network_gateway_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def check_vnet_gateway_exists(*)
          true
        end
      end
    end
  end
end
