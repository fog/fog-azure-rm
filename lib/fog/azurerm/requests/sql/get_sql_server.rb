module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Request
      class Real
        def get_sql_server(resource_group, server_name)
          msg = "Getting Sql Server: #{server_name} in Resource Group: #{resource_group}..."
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Sql/servers/#{server_name}?api-version=2014-04-01-preview"
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
          Fog::Logger.debug "Sql Server fetched successfully in Resource Group: #{resource_group}"
          ::JSON.parse(response)
        end
      end

      # Mock class for Sql Server Request
      class Mock
        def get_sql_server(*)
          {
            'location' => '{server-location}',
            'properties' => {
              'version' => '{server-version}',
              'administratorLogin' => '{admin-name}',
              'administratorLoginPassword' => '{admin-password}'
            }
          }
        end
      end
    end
  end
end
