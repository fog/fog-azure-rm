module ApiStub
  module Models
    module Sql
      # Mock class for Sql Server
      class SqlServer
        # This class contain two mocks, for collection and for model
        def self.create_sql_server
          {
            'id' => "/subscriptions/#{SUBSCRIPTION_ID}/resourceGroups/{resource-group-name}/providers/Microsoft.Sql/servers/{server-name}",
            'name' => 'server-name',
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
