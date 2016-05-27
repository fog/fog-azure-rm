module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def redeploy_virtual_machine(resource_group, name)
          Fog::Logger.debug "Redeploying Virtual Machine #{name} in Resource Group #{resource_group}."
          begin
            promise = @compute_mgmt_client.virtual_machines.redeploy(resource_group, name)
            promise.value!
            Fog::Logger.debug "Virtual Machine #{name} Redeployed Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Redeploying Virtual Machine '#{name}' in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def redeploy_virtual_machine(resource_group, name)
          Fog::Logger.debug "Virtual Machine #{name} from Resource group #{resource_group} Redeployed successfully."
          return true
        end
      end
    end
  end
end
