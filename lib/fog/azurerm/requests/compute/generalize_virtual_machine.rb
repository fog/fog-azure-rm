module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def generalize_virtual_machine(resource_group, name)
          Fog::Logger.debug "Generalizing Virtual Machine #{name} in Resource Group #{resource_group}."
          begin
            promise = @compute_mgmt_client.virtual_machines.generalize(resource_group, name)
            promise.value!
            Fog::Logger.debug "Virtual Machine #{name} Generalized Successfully."
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Generalizing Virtual Machine '#{name}' in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def generalize_virtual_machine(resource_group, name)
        end
      end
    end
  end
end
