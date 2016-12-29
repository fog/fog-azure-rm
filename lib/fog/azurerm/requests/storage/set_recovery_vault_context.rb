module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def set_recovery_vault_context(resource_group, name)
          msg = "Set context for Recovery Vault #{name}"
          Fog::Logger.debug msg

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults/#{name}?api-version=#{REST_CLIENT_API_VERSION[1]}"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue RestClient::Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully set context for Recovery Vault #{name}"
          true
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def set_recovery_vault_context(*)
          Fog::Logger.debug 'Successfully set context for Recovery Vault {name}'
          true
        end
      end
    end
  end
end
