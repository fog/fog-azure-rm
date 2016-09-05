module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_deployment(resource_group, deployment_name)
          msg = "Deleting Deployment: #{deployment_name} in Resource Group: #{resource_group}"
          Fog::Logger.debug msg
          begin
            @rmc.deployments.delete(resource_group, deployment_name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Deployment: #{deployment_name} in Resource Group: #{resource_group} deleted successfully."
          true
        end
      end

      # This class provides the mock implementation
      class Mock
        def delete_deployment(_resource_group, deployment_name)
          Fog::Logger.debug "Deployment: #{deployment_name} deleted successfully."
          true
        end
      end
    end
  end
end
