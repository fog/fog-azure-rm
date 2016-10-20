module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_backup_container(resource_group, rv_name, vm_name)
          msg = "Getting backup container from Recovery Vault #{rv_name}"
          Fog::Logger.debug msg

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults/#{rv_name}/backupProtectionContainers?api-version=2016-05-01&$filter=backupManagementType eq 'AzureIaasVM' and status eq 'Registered' and friendlyName eq '#{vm_name}'"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
              response = resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully retrieved backup container from Recovery Vault #{rv_name}"
          JSON.parse(response)['value']
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def get_backup_container(*)
          body = '{
            "value": [{
              "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupFabrics/Azure/protectionContainers/IaasVMContainer;iaasvmcontainerv2;fog-test-vm-rg;fog-test-vm",
              "name": "IaasVMContainer;iaasvmcontainerv2;fog-test-vm-rg;fog-test-vm",
              "type": "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers",
              "properties": {
                "virtualMachineId": "/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Compute/virtualMachines/TestVM",
                "virtualMachineVersion": "Compute",
                "resourceGroup": "fog-test-vm-rg",
                "friendlyName": "fog-test-vm",
                "backupManagementType": "AzureIaasVM",
                "registrationStatus": "Registered",
                "healthStatus": "Healthy",
                "containerType": "Microsoft.Compute/virtualMachines",
                "protectableObjectType": "Microsoft.Compute/virtualMachines"
              }
            }]
          }'
          JSON.parse(body)['value']
        end
      end
    end
  end
end