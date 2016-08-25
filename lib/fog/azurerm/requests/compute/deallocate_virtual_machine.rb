module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def deallocate_virtual_machine(resource_group, name)
          msg = "Deallocating Virtual Machine #{name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.virtual_machines.deallocate(resource_group, name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Machine #{name} Deallocated Successfully."
          true
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def deallocate_virtual_machine(resource_group, name)
          Fog::Logger.debug "Virtual Machine #{name} from Resource group #{resource_group} Deallocated successfully."
          true
        end
      end
    end
  end
end
