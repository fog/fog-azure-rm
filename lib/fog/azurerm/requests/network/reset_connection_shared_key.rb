module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def reset_connection_shared_key(resource_group_name, virtual_network_gateway_connection_name, shared_key_length)
          msg = "Resetting the shared key of Connection #{virtual_network_gateway_connection_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          shared_key = get_reset_shared_key_object(shared_key_length)
          begin
            @network_client.virtual_network_gateway_connections.reset_shared_key(resource_group_name, virtual_network_gateway_connection_name, shared_key)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          true
        end

        private

        def get_reset_shared_key_object(shared_key_length)
          shared_key = Azure::Network::Profiles::Latest::Mgmt::Models::ConnectionResetSharedKey.new
          shared_key.key_length = shared_key_length
          shared_key
        end
      end

      # Mock class for Network Request
      class Mock
        def reset_connection_shared_key(*)
          Fog::Logger.debug 'Reset the shared key of Connection successfully.'
          true
        end
      end
    end
  end
end
