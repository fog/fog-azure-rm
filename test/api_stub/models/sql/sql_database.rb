module ApiStub
  module Models
    module Sql
      # Mock class for Database
      class SqlDatabase
        # This class contain two mocks, for collection and for model
        def self.create_database
          {
            'id' => '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/vm_custom_image/providers/Microsoft.Sql/servers/test-sql-server-confiz123/databases/confiztestdatab98',
            'location' => '{database-location}',
            'properties' => {
              'createMode' => '{creation-mode}',
              'sourceDatabaseId' => '{source-database-id}',
              'edition' => '{database-edition}',
              'collation' => '{collation-name}',
              'maxSizeBytes' => '{max-database-size}',
              'requestedServiceObjectiveId' => '{requested-service-id}',
              'requestedServiceObjectiveName' => '{requested-service-id}',
              'restorePointInTime' => '{restore-time}',
              'sourceDatabaseDeletionDate' => '{source-deletion-date}',
              'elasticPoolName' => '{elastic-pool-name}'
            }
          }
        end
      end
    end
  end
end
