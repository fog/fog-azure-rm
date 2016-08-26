module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def start_virtual_machine(resource_group, name)
          msg = "Starting Virtual Machine #{name} in Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.virtual_machines.start(resource_group, name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Machine #{name} started Successfully."
          true
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def start_virtual_machine(*)
          Fog::Logger.debug 'Virtual Machine fog-test-server from Resource group fog-test-rg started successfully.'
          true
        end
      end
    end
  end
end
