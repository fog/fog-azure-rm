module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Request
      class Real
        def create_or_update_sql_server(server_hash)
          msg = "Creating SQL Server: #{server_hash[:name]}."
          Fog::Logger.debug msg
          begin
            sql_server = @sql_mgmt_client.servers.create_or_update(server_hash[:resource_group], server_hash[:name], format_server_parameters(server_hash[:location], server_hash[:version], server_hash[:admin_login], server_hash[:admin_password]))
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "SQL Server: #{server_hash[:name]} created successfully."
          sql_server
        end

        private

        def format_server_parameters(location, version, admin_login, admin_password)
          server = Azure::ARM::SQL::Models::Server.new
          server.version = version
          server.location = location
          server.administrator_login = admin_login
          server.administrator_login_password = admin_password
          server
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
