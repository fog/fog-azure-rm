CONFIGURE_BACKUP = 'ConfigureBackup'.freeze

module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def enable_backup_protection(rv_name, rv_resource_group, vm_name, vm_resource_group)
          msg = "Enabling backup protection for VM #{vm_name} in Resource Group #{vm_resource_group}"
          Fog::Logger.debug msg

          set_recovery_vault_context(rv_resource_group, rv_name)
          backup_protection_policy = get_backup_protection_policy(rv_resource_group, rv_name)
          policy = backup_protection_policy.select { |item| item['name'].eql? 'DefaultPolicy' }[0]
          vm_id = get_virtual_machine_id(vm_resource_group, vm_name)

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{rv_resource_group}/providers/Microsoft.RecoveryServices/vaults/#{rv_name}/backupFabrics/Azure/protectionContainers/iaasvmcontainer;iaasvmcontainerv2;#{vm_resource_group.downcase};#{vm_name.downcase}/protectedItems/vm;iaasvmcontainerv2;#{vm_resource_group.downcase};#{vm_name.downcase}?api-version=2016-05-01"
          body = {
            properties: {
              protectedItemType: 'Microsoft.Compute/virtualMachines',
              policyId: policy['id'],
              sourceResourceId: vm_id
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

          @job = get_backup_job_for_vm(rv_name, rv_resource_group, vm_name, vm_resource_group, CONFIGURE_BACKUP)

          until @job.nil?
            sleep 10
            @job = get_backup_job_for_vm(rv_name, rv_resource_group, vm_name, vm_resource_group, CONFIGURE_BACKUP)
          end

          Fog::Logger.debug "Successfully enabled backup protection for VM #{vm_name} in Resource Group #{vm_resource_group}"
          true
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def enable_backup_protection(*)
          Fog::Logger.debug 'Successfully enabled backup protection for VM {vm_name} in Resource Group {vm_resource_group}'
          true
        end
      end
    end
  end
end
