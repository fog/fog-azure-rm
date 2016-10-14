module ApiStub
  module Models
    module Sql
      # Mock class for Sql Server
      class SqlServer
        # This class contain two mocks, for collection and for model
        def self.create_sql_server
          {
            'id' => '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/vm_custom_image/providers/Microsoft.Sql/servers/test-sql-server-confiz123',
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
