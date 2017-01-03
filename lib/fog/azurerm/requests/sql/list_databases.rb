module Fog
  module Sql
    class AzureRM
      # Real class for Sql Database Request
      class Real
        def list_databases(resource_group, server_name)
          msg = "Listing Sql Databases in Resource Group: #{resource_group}."
          Fog::Logger.debug msg
          begin
            databases = @sql_mgmt_client.databases.list_by_server(resource_group, server_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Sql Databases listed successfully in Resource Group: #{resource_group}"
          databases
        end
      end

      # Mock class for Sql Database Request
      class Mock
        def list_databases(*)
          [
            {
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
            },
            {
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
          ]
        end
      end
    end
  end
end
