module Fog
  module Sql
    class AzureRM
      # Real class for Sql Database Request
      class Real
        def delete_database(resource_group, server_name, name)
          msg = "Deleting SQL Database: #{name}."
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Sql/servers/#{server_name}/databases/#{name}?api-version=2014-04-01-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.delete(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
            Fog::Logger.debug "SQL Database: #{name} deleted successfully."
            true
          rescue RestClient::Exception => e
            raise JSON.parse(e.response)['message']
          end
        end
      end

      # Mock class for Sql Database Request
      class Mock
        def delete_database(*)
          Fog::Logger.debug 'SQL Database {name} from Resource group {resource_group} deleted successfully.'
          true
        end
      end
    end
  end
end
