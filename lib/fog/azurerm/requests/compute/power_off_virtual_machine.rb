module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def power_off_virtual_machine(resource_group, name)
          msg = "Powering off Virtual Machine #{name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.virtual_machines.power_off(resource_group, name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Machine #{name} Powered off Successfully."
          true
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def power_off_virtual_machine(resource_group, name)
          Fog::Logger.debug "Virtual Machine #{name} from Resource group #{resource_group} Powered off successfully."
          true
        end
      end
    end
  end
end
