module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def generalize_virtual_machine(resource_group, name)
          msg = "Generalizing Virtual Machine #{name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.virtual_machines.generalize(resource_group, name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Machine #{name} Generalized Successfully."
          true
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def generalize_virtual_machine(*)
          Fog::Logger.debug 'Virtual Machine fog-test-server from Resource group fog-test-rg Generalized successfully.'
          true
        end
      end
    end
  end
end
