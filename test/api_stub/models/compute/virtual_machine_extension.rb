module ApiStub
  module Models
    module Compute
      # Mock class for VirtualMachineExtension model
      class VirtualMachineExtension
        def self.create_vm_extension_response(compute_client)
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
          compute_client.deserialize(extension_mapper, body, 'result.body')
        end
      end
    end
  end
end
