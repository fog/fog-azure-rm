module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_recovery_vault(resource_group, name)
          msg = "Retrieving Recovery Vault #{name} from Resource Group #{resource_group}"
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults?api-version=#{REST_CLIENT_API_VERSION[1]}"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            recovery_vault_response = RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue RestClient::Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Recovery Vault #{name} from Resource Group #{resource_group} retrieved successfully"
          recovery_vault = Fog::JSON.decode(recovery_vault_response)['value']
          recovery_vault.select { |vault| vault['name'].eql? name }[0]
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def get_recovery_vault(*)
          body = '{
            "value": [{
              "location": "westus",
              "name": "fog-test-vault",
              "properties": {
                "provisioningState": "Succeeded"
              },
              "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault",
              "type": "Microsoft.RecoveryServices/vaults",
              "sku": {
                "name": "standard"
              }
            }]
          }'
          Fog::JSON.decode(body)['value'][0]
        end
      end
    end
  end
end
