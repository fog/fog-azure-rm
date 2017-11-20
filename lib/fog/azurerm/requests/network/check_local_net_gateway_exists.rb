module Fog
  module Network
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_local_net_gateway_exists(resource_group_name, local_network_gateway_name)
          msg = "Checking Local Network Gateway #{local_network_gateway_name}"
          Fog::Logger.debug msg
          begin
            @network_client.local_network_gateways.get(resource_group_name, local_network_gateway_name)
            Fog::Logger.debug "Local Network Gateway #{local_network_gateway_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if resource_not_found?(e)
              Fog::Logger.debug "Local Network Gateway #{local_network_gateway_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_local_net_gateway_exists(*)
          true
        end
      end
    end
  end
end
