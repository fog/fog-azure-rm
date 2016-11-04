module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_backup_item(resource_group, rv_name)
          msg = "Getting backup item from Recovery Vault #{rv_name}"
          Fog::Logger.debug msg

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults/#{rv_name}/backupProtectedItems?api-version=2016-05-01&$filter=backupManagementType eq 'AzureIaasVM' and itemType eq 'VM'"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
              response = resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue RestClient::Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully retrieved backup item from Recovery Vault #{rv_name}"
          ::JSON.parse(response)['value']
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def get_backup_item(*)
          body = '{
            "value": [{
              "id": "/Subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupFabrics/Azure/protectionContainers/IaasVMContainer;iaasvmcontainerv2;testrg;testvm/protectedItems/VM;fog-test-container-name",
              "name": "iaasvmcontainerv2;fog-test-vm-rg;fog-test-vm",
              "type": "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems",
              "properties": {
                "friendlyName": "fog-test-vm",
                "virtualMachineId": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-vm-rg/providers/Microsoft.Compute/virtualMachines/fog-test-vm",
                "protectionStatus": "Healthy",
                "protectionState": "Protected",
                "lastBackupStatus": "Completed",
                "lastBackupTime": "2016-10-17T10:30:47.2289274Z",
                "protectedItemType": "Microsoft.Compute/virtualMachines",
                "backupManagementType": "AzureIaasVM",
                "workloadType": "VM",
                "containerName": "iaasvmcontainerv2;fog-test-vm-rg;fog-test-vm",
                "sourceResourceId": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-vm-rg/providers/Microsoft.Compute/virtualMachines/fog-test-vm",
                "policyId": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupPolicies/DefaultPolicy",
                "policyName": "DefaultPolicy",
                "lastRecoveryPoint": "2016-10-17T10:32:38.4666692Z"
              }
            }]
          }'
          ::JSON.parse(body)['value']
        end
      end
    end
  end
end
