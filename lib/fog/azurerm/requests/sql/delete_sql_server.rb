module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Request
      class Real
        def delete_sql_server(resource_group, name)
          msg = "Deleting SQL Server: #{name}."
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Sql/servers/#{name}?api-version=2014-04-01-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.delete(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
          rescue RestClient::Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "SQL Server: #{name} deleted successfully."
          true
        end
      end

      # Mock class for Sql Server Request
      class Mock
        def delete_sql_server(*)
          Fog::Logger.debug 'SQL Server {name} from Resource group {resource_group} deleted successfully.'
          true
        end
      end
    end
  end
end
