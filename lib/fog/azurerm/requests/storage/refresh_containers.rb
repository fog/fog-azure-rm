module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def refresh_containers(resource_group, name)
          msg = "Refreshing containers for Recovery Vault #{name}"
          Fog::Logger.debug msg

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults/#{name}/backupFabrics/Azure/refreshContainers?api-version=2016-05-01"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.post(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully refreshed containers for Recovery Vault #{name}"
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def refresh_containers(*)

        end
      end
    end
  end
end