module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def delete_vm_extension(resource_group, vm_name, extension_name)
          msg = "Deleting Extension #{extension_name} of Virtual Machine #{vm_name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.virtual_machine_extensions.delete(resource_group, vm_name, extension_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Extension #{extension_name} of Virtual Machine #{vm_name} in Resource Group #{resource_group} deleted successfully"
          true
        end
      end

      # Mock class for Compute Request
      class Mock
        def delete_vm_extension(*)
          Fog::Logger.debug 'Extension extension_name of Virtual Machine vm_name in Resource Group resource_group deleted successfully'
          true
        end
      end
    end
  end
end