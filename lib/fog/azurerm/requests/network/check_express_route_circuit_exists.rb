module Fog
  module Network
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_express_route_circuit_exists(resource_group_name, circuit_name)
          msg = "Checking Express Route Circuit #{circuit_name}"
          Fog::Logger.debug msg
          begin
            @network_client.express_route_circuits.get(resource_group_name, circuit_name)
            Fog::Logger.debug "Express Route Circuit #{circuit_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if resource_not_found?(e)
              Fog::Logger.debug "Express Route Circuit #{circuit_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_express_route_circuit_exists(*)
          true
        end
      end
    end
  end
end
