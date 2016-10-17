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
          puts backup_protection_policy.inspect
          policy = backup_protection_policy.select { |item| item['name'].eql? 'DefaultPolicy' }[0]
          backup_protectable_items = get_backup_protectable_items(rv_resource_group, rv_name)
          puts backup_protectable_items.inspect
          backup_item = backup_protectable_items.select { |item| (item['properties']['friendlyName'].eql? vm_name) && (item['properties']['resourceGroup'].eql? vm_resource_group) }[0]

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{rv_resource_group}/providers/Microsoft.RecoveryServices/vaults/#{rv_name}/backupFabrics/Azure/protectionContainers/iaasvmcontainer;#{backup_item['name']}/protectedItems/vm;#{backup_item['name']}?api-version=2016-05-01"
          body = {
            properties: {
              protectedItemType: 'Microsoft.Compute/virtualMachines',
              policyId: policy['id'],
              sourceResourceId: backup_item['properties']['virtualMachineId']
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
          rescue Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully enabled backup protection for VM #{vm_name} in Resource Group #{vm_resource_group}"
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def enable_backup_protection(*)

        end
      end
    end
  end
end