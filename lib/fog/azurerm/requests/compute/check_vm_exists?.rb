module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_vm_exists?(resource_group, name)
          msg = "Checking Virtual Machine #{name}"
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.virtual_machines.get(resource_group, name, 'instanceView')
            Fog::Logger.debug "Virtual machine #{name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Virtual machine #{name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_vm_exists?(_resource_group, _name)
          true
        end
      end
    end
  end
end
