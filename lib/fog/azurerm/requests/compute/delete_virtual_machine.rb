module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_virtual_machine(resource_group, name)
          Fog::Logger.debug "Deleting Virtual Machine #{name} from Resource Group #{resource_group}."
          begin
            promise = @compute_mgmt_client.virtual_machines.delete(resource_group, name)
            result = promise.value!
            Fog::Logger.debug "Virtual Machine #{name} Deleted Successfully."
            result
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Deleting Virtual Machine '#{name}' from Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_virtual_machine(resource_group, name)
        end
      end
    end
  end
end
