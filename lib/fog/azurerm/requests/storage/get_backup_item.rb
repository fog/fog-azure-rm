module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_backup_item(resource_group, rv_name, vm_name)
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
          rescue Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully retrieved backup item from Recovery Vault #{rv_name}"
          JSON.parse(response)['value']
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def get_backup_item(*)

        end
      end
    end
  end
end