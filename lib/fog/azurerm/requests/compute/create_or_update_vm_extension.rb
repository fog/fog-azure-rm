module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def create_or_update_vm_extension(vm_extension_params)
          msg = "Creating/Updating Extension #{vm_extension_params[:name]} for Virtual Machine #{vm_extension_params[:vm_name]} in Resource Group #{vm_extension_params[:resource_group]}"
          Fog::Logger.debug msg

          vm_extension = create_virtual_machine_extension_object(vm_extension_params)
          begin
            vm_extension_obj = @compute_mgmt_client.virtual_machine_extensions.create_or_update(vm_extension_params[:resource_group], vm_extension_params[:vm_name], vm_extension_params[:name], vm_extension)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Extension #{vm_extension.name} for Virtual Machine #{vm_extension_params[:vm_name]} in Resource Group #{vm_extension_params[:resource_group]} created/updated successfully"
          vm_extension_obj
        end

        private

        def create_virtual_machine_extension_object(virtual_machine_extension)
          vm_extension = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualMachineExtension.new
          vm_extension.name = virtual_machine_extension[:name]
          vm_extension.location = virtual_machine_extension[:location]
          vm_extension.virtual_machine_extension_type = virtual_machine_extension[:type]
          vm_extension.publisher = virtual_machine_extension[:publisher]
          vm_extension.type_handler_version = virtual_machine_extension[:type_handler_version]
          vm_extension.auto_upgrade_minor_version = virtual_machine_extension[:auto_upgrade_minor_version]
          vm_extension.settings = virtual_machine_extension[:settings]
          vm_extension.protected_settings = virtual_machine_extension[:protected_settings]
          vm_extension
        end
      end

      # Mock class for Compute Request
      class Mock
        def add_or_update_vm_extension(*)
          body = {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Compute/virtualMachines/TestVM/extensions/IaaSAntimalware',
            'name' => 'IaasAntimalware',
            'resource_group' => 'fog-test-rg',
            'location' => 'West US',
            'properties' => {
              'publisher' => 'Microsoft.Azure.Security',
              'type' => 'IaaSAntimalware',
              'typeHandlerVersion' => '1.3',
              'autoUpgradeMinorVersion' => 'true',
              'forceUpdateTag' => 'RerunExtension',
              'settings' => {
                'AnitmalwareEnabled' => 'true',
                'RealtimeProtectionEnabled' => 'false'
              },
              'protected_settings' => {}
            }
          }
          extension_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualMachineExtension.mapper
          @compute_mgmt_client.deserialize(extension_mapper, body, 'result.body')
        end
      end
    end
  end
end
