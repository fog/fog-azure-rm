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
        def get_vm_extension(*)
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
