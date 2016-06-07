module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def start_virtual_machine(resource_group, name)
          Fog::Logger.debug "Starting Virtual Machine #{name} in Resource Group #{resource_group}."
          begin
            promise = @compute_mgmt_client.virtual_machines.start(resource_group, name)
            promise.value!
            Fog::Logger.debug "Virtual Machine #{name} started Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error starting Virtual Machine '#{name}' in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def start_virtual_machine(resource_group, name)
          Fog::Logger.debug "Virtual Machine #{name} from Resource group #{resource_group} started successfully."
          true
        end
      end
    end
  end
end
