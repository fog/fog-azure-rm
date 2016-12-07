module ApiStub
  module Models
    module Sql
      # Mock class for Database
      class SqlDatabase
        # This class contain two mocks, for collection and for model
        def self.create_database
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/{resource-group-name}/providers/Microsoft.Sql/servers/{test-sql-server-name}/databases/{database-name}',
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
