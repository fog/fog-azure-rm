module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def add_or_update_vm_extension(vm_extension_params)
          msg = "Creating/Updating Extension #{vm_extension_params[:vm_extension_name]} for Virtual Machine #{vm_extension_params[:virtual_machine_name]} in Resource Group #{vm_extension_params[:resource_group]}"
          Fog::Logger.debug msg

          vm_extension = create_virtual_machine_extension(vm_extension_params)
          begin
            @compute_mgmt_client.virtual_machine_extensions.create_or_update(vm_extension_params[:resource_group], vm_extension_params[:virtual_machine_name], vm_extension_params[:vm_extension_name], vm_extension)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Extension #{vm_extension.name} for Virtual Machine #{vm_extension_params[:virtual_machine_name]} in Resource Group #{vm_extension_params[:resource_group]} created/updated successfully"
          true
        end

        def create_virtual_machine_extension(virtual_machine_extension)
          vm_extension = Azure::ARM::Compute::Models::VirtualMachineExtension.new
          vm_extension.name = virtual_machine_extension[:vm_extension_name]
          vm_extension.location = virtual_machine_extension[:location]
          vm_extension.virtual_machine_extension_type = virtual_machine_extension[:vm_extension_type]
          vm_extension.publisher = virtual_machine_extension[:vm_extension_publisher]
          vm_extension.type_handler_version = virtual_machine_extension[:vm_extension_version]
          vm_extension
        end
      end

      # Mock class for Compute Request
      class Mock

      end
    end
  end
end