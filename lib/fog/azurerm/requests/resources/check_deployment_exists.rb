module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_deployment_exists(resource_group_name, deployment_name)
          msg = "Checking Deployment #{deployment_name}"
          Fog::Logger.debug msg
          begin
            flag = @rmc.deployments.check_existence(resource_group_name, deployment_name)
            if flag
              Fog::Logger.debug "Deployment #{deployment_name} exists."
            else
              Fog::Logger.debug "Deployment #{deployment_name} doesn't exist."
            end
            flag
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_deployment_exists(*)
          true
        end
      end
    end
  end
end
