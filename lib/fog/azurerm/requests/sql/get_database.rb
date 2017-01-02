module Fog
  module Sql
    class AzureRM
      # Real class for Sql Database Request
      class Real
        def get_database(resource_group, server_name, name)
          msg = "Getting Sql Database: #{name} in Resource Group: #{resource_group}."
          Fog::Logger.debug msg

          begin
            database = @sql_mgmt_client.databases.get(resource_group, server_name, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Sql Database fetched successfully in Resource Group: #{resource_group}"
          database
        end
      end

      # Mock class for Sql Database Request
      class Mock
        def get_database(*)
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
        end
      end
    end
  end
end
