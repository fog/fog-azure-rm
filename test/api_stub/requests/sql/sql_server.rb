module ApiStub
  module Requests
    module Sql
      # Mock class for Sql Server
      class SqlServer
        def self.create_sql_server_response(sql_manager_client)
          body = '{
            "location" : "{server-location}",
            "properties" : {
              "version" : "{server-version}",
              "administratorLogin" : "{admin-name}",
              "administratorLoginPassword" : "{admin-password}"
            }
          }'
          server_mapper = Azure::ARM::SQL::Models::Server.mapper
          sql_manager_client.deserialize(server_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.list_sql_server_response(sql_manager_client)
          body = '{
            "value": [{
              "name" : "{database-name}",
              "server_name" : "{server-name}",
              "location" : "{database-location}",
              "properties" : {
                "version" : "{server-version}",
                "administratorLogin" : "{admin-name}",
                "administratorLoginPassword" : "{admin-password}"
              }
            }]
          }'
          server_mapper = Azure::ARM::SQL::Models::ServerListResult.mapper
          sql_manager_client.deserialize(server_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.sql_server_hash
          {
            resource_group: 'resource_group',
            name: 'name',
            version: 'version',
            location: 'location',
            administrator_login: 'administrator_login',
            administrator_login_password: 'administrator_login_password'
          }
        end
      end
    end
  end
end
