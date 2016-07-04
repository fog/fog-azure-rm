module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_deployment(resource_group, deployment_name)
          begin
            Fog::Logger.debug "Deleting Deployment: #{deployment_name} in Resource Group: #{resource_group}"
            @rmc.deployments.delete(resource_group, deployment_name).value!
            Fog::Logger.debug "Deployment: #{deployment_name} in Resource Group: #{resource_group} deleted successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Deployment: #{deployment_name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
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
