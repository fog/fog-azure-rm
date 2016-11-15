module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def create_or_update_recovery_vault(resource_group, location, name)
          msg = "Creating/Updating Recovery Vault #{name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg

          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults/#{name}?api-version=2016-05-01"
          body = {
            location: location,
            tags: {},
            sku: { name: 'standard' },
            properties: {}
          }
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.put(
              resource_url,
              body.to_json,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue RestClient::Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Recovery Vault #{name} created/updated successfully"
          ::JSON.parse(response)
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def create_or_update_recovery_vault(*)
          recovery_vault = '{
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
          }'
          ::JSON.parse(recovery_vault)
        end
      end
    end
  end
end
