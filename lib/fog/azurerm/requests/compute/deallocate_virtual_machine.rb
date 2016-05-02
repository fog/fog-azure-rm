module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def deallocate_virtual_machine(resource_group, name)
          Fog::Logger.debug "Deallocating Virtual Machine #{name} in Resource Group #{resource_group}."
          begin
            promise = @compute_mgmt_client.virtual_machines.deallocate(resource_group, name)
            result = promise.value!
            Fog::Logger.debug "Virtual Machine #{name} Deallocated Successfully."
            result
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Deallocating Virtual Machine '#{name}' in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def deallocate_virtual_machine(resource_group, name)
        end
      end
    end
  end
end
