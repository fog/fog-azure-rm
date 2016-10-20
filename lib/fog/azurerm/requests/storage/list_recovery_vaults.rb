module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def list_recovery_vaults(resource_group)
          msg = "Listing Recovery Vaults in Resource Group #{resource_group}"
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.RecoveryServices/vaults?api-version=2016-05-01"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            recovery_vaults_response = RestClient.get(
              resource_url,
              accept: 'application/json',
              content_type: 'application/json',
              authorization: token
            )
          rescue Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Recovery Vaults in Resource Group #{resource_group} listed successfully"
          JSON.parse(recovery_vaults_response)['value']
        end
      end

      # Mock class for Recovery Vault Request
      class Mock
        def list_recovery_vaults(*)
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
          JSON.parse(body)['value']
        end
      end
    end
  end
end