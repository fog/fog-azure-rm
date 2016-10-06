module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_virtual_network_gateway_connection(resource_group_name, gateway_connection_name)
          msg = @logger_messages['network']['virtual_network_gateway_connection']['message']['delete']
                .gsub('NAME', gateway_connection_name).gsub('RESOURCE_GROUP', resource_group_name)
          Fog::Logger.debug msg
          begin
            @network_client.virtual_network_gateway_connections.delete(resource_group_name, gateway_connection_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Network Gateway Connection #{gateway_connection_name} Deleted Successfully."
          true
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_virtual_network_gateway_connection(*)
          Fog::Logger.debug 'Virtual Network Gateway Connection deleted successfully.'
          true
        end
      end
    end
  end
end
