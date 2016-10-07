module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Request
      class Real
        def create_or_update_sql_server(server_hash)
          msg = "Creating SQL Server: #{server_hash[:name]}."
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{server_hash[:resource_group]}/providers/Microsoft.Sql/servers/#{server_hash[:name]}?api-version=2014-04-01-preview"
          request_parameters = format_request_parameters(server_hash[:location], server_hash[:version], server_hash[:administrator_login], server_hash[:administrator_login_password])
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.put(
              resource_url,
              request_parameters.to_json,
              accept: :json,
              content_type: :json,
              authorization: token
            )

          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, JSON.parse(e.response)['message'])
          end
          Fog::Logger.debug "SQL Server: #{server_hash[:name]} created successfully."
          JSON.parse(response)
        end

        private
        def format_request_parameters(location, version, admin_login, admin_password)
          parameters = {}
          properties = {}

          properties['version'] = version
          properties['administratorLogin'] = admin_login
          properties['administratorLoginPassword'] = admin_password

          parameters['properties'] = properties
          parameters['location'] = location
          parameters['tags'] = {}

          parameters
        end

      end

      # Mock class for Sql Server Request
      class Mock
        def create_or_update_sql_server(*)
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
