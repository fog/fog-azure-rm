module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_backup_protection_policy(resource_group, name)
          msg = "Get backup protection policy from Resource Group #{resource_group}"
          Fog::Logger.debug msg

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults/#{name}/backupPolicies?api-version=2016-05-01&$filter=backupManagementType eq 'AzureIaasVM'"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: token
            )
          rescue Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully retrieved backup protection policy from Resource Group #{resource_group}"
          JSON.parse(response)['value']
        end
      end

      # Mock class for Recovery Vault request
      class Mock

      end
    end
  end
end