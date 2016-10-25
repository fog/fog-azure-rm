PROTECTION_STOPPED = 'ProtectionStopped'.freeze

module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def disable_backup_protection(rv_name, rv_resource_group, vm_name, vm_resource_group)
          msg = "Disabling protection for VM #{vm_name} in Recovery Vault #{rv_name}"
          Fog::Logger.debug msg

          set_recovery_vault_context(rv_resource_group, rv_name)
          vm_id = get_virtual_machine_id(vm_resource_group, vm_name)

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{rv_resource_group}/providers/Microsoft.RecoveryServices/vaults/#{rv_name}/backupFabrics/Azure/protectionContainers/iaasvmcontainer;iaasvmcontainerv2;#{vm_resource_group.downcase};#{vm_name.downcase}/protectedItems/vm;iaasvmcontainerv2;#{vm_resource_group.downcase};#{vm_name.downcase}?api-version=2016-05-01"
          body = {
            properties: {
              protectedItemType: 'Microsoft.Compute/virtualMachines',
              policyId: '',
              sourceResourceId: vm_id,
              protectionState: PROTECTION_STOPPED
            },
            tags: {}
          }

          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.put(
              resource_url,
              body.to_json,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue RestClient::Exception => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Successfully disabled protection for VM #{vm_name} in Recovery Vault #{rv_name}"
          true
        end

        private
        
        def get_virtual_machine_id(vm_resource_group, vm_name)
          compute_service = Fog::Compute::AzureRM.new(tenant_id: @tenant_id, client_id: @client_id, client_secret: @client_secret, subscription_id: @subscription_id)
          compute_service.get_virtual_machine(vm_resource_group, vm_name).id
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def disable_backup_protection(*)
          Fog::Logger.debug 'Successfully disabled protection for VM {vm_name} in Recovery Vault {rv_name}'
          true
        end
      end
    end
  end
end
