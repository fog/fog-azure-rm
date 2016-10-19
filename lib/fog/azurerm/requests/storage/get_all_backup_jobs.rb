module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_all_backup_jobs(rv_name, rv_resource_group)
          msg = "Getting all backup jobs for Recovery Vault #{rv_name}"
          Fog::Logger.debug msg

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{rv_resource_group}/providers/Microsoft.RecoveryServices/vaults/#{rv_name}/backupJobs?api-version=2016-05-01&$filter=status eq 'InProgress'"
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
          Fog::Logger.debug "Successfully retrieved backup jobs for Recovery Vault #{rv_name}"
          JSON.parse(response)['value']
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def get_all_backup_jobs(*)

        end
      end
    end
  end
end