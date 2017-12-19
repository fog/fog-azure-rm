module Fog
  module Network
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_load_balancer_exists(resource_group_name, load_balancer_name)
          msg = "Checking Load Balancer #{load_balancer_name}"
          Fog::Logger.debug msg
          begin
            @network_client.load_balancers.get(resource_group_name, load_balancer_name)
            Fog::Logger.debug "Load Balancer #{load_balancer_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if resource_not_found?(e)
              Fog::Logger.debug "Load Balancer #{load_balancer_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_load_balancer_exists(*)
          true
        end
      end
    end
  end
end
