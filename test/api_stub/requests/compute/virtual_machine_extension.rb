module ApiStub
  module Requests
    module Compute
      # Mock class for VirtualMachineExtension Requests
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

        def self.vm_extension_params
          {
            resource_group: 'TestRG',
            location: 'eastus',
            vm_name: 'TestVM',
            name: 'IaaSAntimalware',
            publisher: 'Microsoft.Azure.Security',
            type: 'IaaSAntimalware',
            type_handler_version: '1.3',
            auto_upgrade_minor_version: true,
            settings: '{"AntimalwareEnabled": "true", "RealtimeProtectionEnabled": "false", "ScheduledScanSettings": {"isEnabled": "false", "day": "7", "time": "120", "scanType": "Quick"}, "Exclusions": {"Extensions": "", "Paths": "", "Processes": ""}}',
            protected_settings: '{}'
          }
        end
      end
    end
  end
end
