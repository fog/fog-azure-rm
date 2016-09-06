module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def set_connection_shared_key(resource_group_name, virtual_network_gateway_connection_name, shared_key_value)
          msg = "Setting the shared key of Connection #{virtual_network_gateway_connection_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          shared_key = get_shared_key(shared_key_value)
          begin
            @network_client.virtual_network_gateway_connections.set_shared_key(resource_group_name, virtual_network_gateway_connection_name, shared_key).value
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Setting the shared key of Connection #{virtual_network_gateway_connection_name} Deleted Successfully."
          true
        end

        private

        def get_shared_key_object(shared_key_value)
          shared_key = Azure::ARM::Network::Models::ConnectionSharedKey.new
          shared_key.value = shared_key_value
          shared_key
        end
      end

      # Mock class for Network Request
      class Mock
        def set_connection_shared_key(*)
          Fog::Logger.debug 'Set the shared key of Connection successfully.'
        end
      end
    end
  end
end
