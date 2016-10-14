module ApiStub
  module Requests
    module Sql
      # Mock class for Sql Server
      class SqlServer
        def self.create_sql_server_response
          '{
            "location" : "{server-location}",
            "properties" : {
              "version" : "{server-version}",
              "administratorLogin" : "{admin-name}",
              "administratorLoginPassword" : "{admin-password}"
            }
          }'
        end

        def self.list_sql_server_response
          '{
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
