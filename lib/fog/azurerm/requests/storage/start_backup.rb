module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def start_backup(resource_group, name, vm_name, vm_resource_group)
          msg = "Starting backup for VM #{vm_name}"
          Fog::Logger.debug msg

          job = get_backup_job_for_vm(name, resource_group, vm_name, vm_resource_group, 'Backup')

          if job.nil?
            backup_items = get_backup_item(resource_group, name, vm_name)
            backup_item = backup_items.select { |item| (item['properties']['friendlyName'].eql? vm_name.downcase) &&  (vm_resource_group.eql? get_resource_group_from_id(item['properties']['virtualMachineId'])) }[0]

            resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults/#{name}/backupFabrics/Azure/protectionContainers/iaasvmcontainer;#{backup_item['name']}/protectedItems/vm;#{backup_item['name']}/backup?api-version=2016-05-01"
            body = {
              properties: {
                objectType: 'IaasVMBackupRequest'
              }
            }
            begin
              token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
              RestClient.post(
                resource_url,
                body.to_json,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token
            )
            rescue Exception => e
              raise_azure_exception(e, msg)
            end
            Fog::Logger.debug "Successfully started backup for VM #{vm_name} in Recovery Vault #{name}"
            true
          else
            Fog::Logger.debug "Backup already in progress for VM #{vm_name} in Recovery Vault #{name}"
            false
          end
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def start_backup(*)
          Fog::Logger.debug 'Successfully started backup for VM {vm_name} in Recovery Vault {name}'
          true
        end
      end
    end
  end
end