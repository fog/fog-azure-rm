module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_vm_exists(resource_group, name, async)
          msg = "Checking Virtual Machine #{name}"
          Fog::Logger.debug msg
          begin
            if async
              response = @compute_mgmt_client.virtual_machines.get_async(resource_group, name, 'instanceView')
            else
              @compute_mgmt_client.virtual_machines.get(resource_group, name, 'instanceView')
            end
          rescue MsRestAzure::AzureOperationError => e
            if check_resource_existence_exception(e)
              raise_azure_exception(e, msg)
            else
              Fog::Logger.debug "Virtual machine #{name} doesn't exist."
              return false
            end
          end
          if async
            response
          else
            Fog::Logger.debug "Virtual machine #{name} exists."
            true
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_vm_exists(_resource_group, _name)
          true
        end
      end
    end
  end
end
