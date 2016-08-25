module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def power_off_virtual_machine(resource_group, name)
          Fog::Logger.debug "Powering off Virtual Machine #{name} in Resource Group #{resource_group}."
          begin
            promise = @compute_mgmt_client.virtual_machines.power_off(resource_group, name)
            promise.value!
            Fog::Logger.debug "Virtual Machine #{name} Powered off Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Powering off Virtual Machine '#{name}' in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
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
