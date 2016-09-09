module Fog
  module Network
    class AzureRM
      # Real class for Local Network Gateway Request
      class Real
        def delete_local_network_gateway(resource_group_name, local_network_gateway_name)
          msg = "Deleting Local Network Gateway: #{local_network_gateway_name}"
          Fog::Logger.debug msg
          begin
            @network_client.local_network_gateways.delete(resource_group_name, local_network_gateway_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Local Network Gateway #{local_network_gateway_name} from Resource group #{resource_group_name} deleted successfully."
          true
        end
      end

      # Mock class for Local Network Gateway Request
      class Mock
        def delete_local_network_gateway(*)
          Fog::Logger.debug 'Local Network Gateway testLocalNetworkGateway from Resource group learn_fog deleted successfully.'
          true
        end
      end
    end
  end
end
