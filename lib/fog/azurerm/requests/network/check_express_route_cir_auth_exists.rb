module Fog
  module Network
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_express_route_cir_auth_exists(resource_group_name, circuit_name, authorization_name)
          msg = "Checking Express Route Circuit Authorization #{authorization_name}"
          Fog::Logger.debug msg
          begin
            @network_client.express_route_circuit_authorizations.get(resource_group_name, circuit_name, authorization_name)
            Fog::Logger.debug "Express Route Circuit Authorization #{authorization_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if check_resource_existence_exception(e)
              raise_azure_exception(e, msg)
            else
              Fog::Logger.debug "Express Route Circuit Authorization #{authorization_name} doesn't exist."
              false
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_express_route_cir_auth_exists(*)
          true
        end
      end
    end
  end
end
