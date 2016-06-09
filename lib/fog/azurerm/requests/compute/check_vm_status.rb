module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def check_vm_status(resource_group, name)
          Fog::Logger.debug "Checking Virtual Machine #{name} status."
          begin
            # Pass 'instanceView' in get method, as argument, to get Virtual Machine status.
            promise = @compute_mgmt_client.virtual_machines.get(resource_group, name, 'instanceView')
            response = promise.value!
            virtual_machine = response.body
            get_status(virtual_machine)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error in checking Virtual Machine '#{name}' status in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end

        def get_status(virtual_machine)
          vm_statuses = virtual_machine.properties.instance_view.statuses
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
