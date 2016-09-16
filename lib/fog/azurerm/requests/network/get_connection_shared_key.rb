module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def get_connection_shared_key(resource_group_name, connection_shared_key_name)
          msg = "Getting the shared key of Connection #{connection_shared_key_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            @network_client.virtual_network_gateway_connections.get_shared_key(resource_group_name, connection_shared_key_name).value
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def get_connection_shared_key(*)
          Fog::Logger.debug 'Get the shared key of Connection successfully.'
        end
      end
    end
  end
end
