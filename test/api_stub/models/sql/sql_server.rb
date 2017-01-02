module ApiStub
  module Models
    module Sql
      # Mock class for Sql Server
      class SqlServer
        # This class contain two mocks, for collection and for model
        def self.create_sql_server(server_manager_client)
          sql_server = '{
            "id" : "/subscriptions/########-####-####-####-############/resourceGroups/{resource-group-name}/providers/Microsoft.Sql/servers/{server-name}",
            "name" : "server-name",
            "location" : "{server-location}",
            "properties" : {
              "version" : "{server-version}",
              "administratorLogin" : "{admin-name}",
              "administratorLoginPassword" : "{admin-password}"
            }
          }'
          server_mapper = Azure::ARM::SQL::Models::Server.mapper
          server_manager_client.deserialize(server_mapper, Fog::JSON.decode(sql_server), 'result.body')
        end
      end
    end
  end
end
