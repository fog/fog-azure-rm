module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def restart_virtual_machine(resource_group, name)
          Fog::Logger.debug "Restarting Virtual Machine #{name} in Resource Group #{resource_group}."
          begin
            promise = @compute_mgmt_client.virtual_machines.restart(resource_group, name)
            promise.value!
            Fog::Logger.debug "Virtual Machine #{name} Restarted Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Restarting Virtual Machine '#{name}' in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def restart_virtual_machine(resource_group, name)
          Fog::Logger.debug "Virtual Machine #{name} from Resource group #{resource_group} Restarted successfully."
          true
        end
      end
    end
  end
end
