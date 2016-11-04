module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Request
      class Real
        def list_sql_servers(resource_group)
          msg = "Listing Sql Servers in Resource Group: #{resource_group}."
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Sql/servers?api-version=2014-04-01-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
          rescue RestClient::Exception => e
            raise ::JSON.parse(e.response)['message']
          end
          Fog::Logger.debug "Sql Servers listed successfully in Resource Group: #{resource_group}"
          ::JSON.parse(response)['value']
        end
      end

      # Mock class for Sql Server Request
      class Mock
        def list_sql_servers(*)
          [
            {
              'location' => '{server-location}',
              'properties' => {
                'version' => '{server-version}',
                'administratorLogin' => '{admin-name}',
                'administratorLoginPassword' => '{admin-password}'
              }
            },
            {
              'location' => '{server-location}',
              'properties' => {
                'version' => '{server-version}',
                'administratorLogin' => '{admin-name}',
                'administratorLoginPassword' => '{admin-password}'
              }
            }
          ]
        end
      end
    end
  end
end
