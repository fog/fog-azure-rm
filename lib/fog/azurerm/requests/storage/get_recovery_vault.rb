module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_recovery_vault(resource_group, name)
          msg = "Retrieving Recovery Vault #{name} from Resource Group #{resource_group}"
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults?api-version=2016-05-01"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            recovery_vault_response = RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Recovery Vault #{name} from Resource Group #{resource_group} retrieved successfully"
          JSON.parse(recovery_vault_response)
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def get_recovery_vault(*)

        end
      end
    end
  end
end