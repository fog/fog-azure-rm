module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def get_vm_extension(resource_group_name, virtual_machine_name, vm_extension_name)
          msg = "Getting Extension #{vm_extension_name} of Virtual Machine #{virtual_machine_name} in Resource Group #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            vm_extension = @compute_mgmt_client.virtual_machine_extensions.get(resource_group_name, virtual_machine_name, vm_extension_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "#{msg} successful"
          vm_extension
        end
      end

      # Mock class for Compute Request
      class Mock

      end
    end
  end
end