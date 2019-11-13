module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_vm_status(resource_group, name, async)
          msg = "Checking Virtual Machine #{name} status"
          Fog::Logger.debug msg
          begin
            virtual_machine = @compute_mgmt_client.virtual_machines.get(resource_group, name, expand: 'instanceView')
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully returned status of Virtual Machine #{name} in Resource Group #{resource_group}"
          get_status(virtual_machine)
        end

        def get_status(virtual_machine)
          vm_statuses = virtual_machine.instance_view.statuses
          vm_status = nil
          vm_statuses.each do |status|
            if status.code.include? 'PowerState'
              Fog::Logger.debug status.display_status.to_s
              vm_status = status.code.split('/')[1]
            end
          end
          vm_status
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_vm_status(_resource_group, _name)
          'running'
        end
      end
    end
  end
end
