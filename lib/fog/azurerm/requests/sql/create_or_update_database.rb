module Fog
  module Sql
    class AzureRM
      # Real class for Sql Database Request
      class Real
        def create_or_update_database(database_hash)
          msg = "Creating SQL Database: #{database_hash[:name]}."
          Fog::Logger.debug msg
          formatted_database_params = format_database_parameters(database_hash[:location],
                                                                 database_hash[:create_mode],
                                                                 database_hash[:edition],
                                                                 database_hash[:source_database_id],
                                                                 database_hash[:collation],
                                                                 database_hash[:max_size_bytes],
                                                                 database_hash[:requested_service_objective_name],
                                                                 database_hash[:elastic_pool_name],
                                                                 database_hash[:requested_service_objective_id],
                                                                 database_hash[:tags])
          begin
            sql_database = @sql_mgmt_client.databases.create_or_update(database_hash[:resource_group],
                                                                       database_hash[:server_name],
                                                                       database_hash[:name],
                                                                       formatted_database_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "SQL Database: #{database_hash[:name]} created successfully."
          sql_database
        end

        private

        def format_database_parameters(location, create_mode, edition, source_database_id, collation, max_size_bytes, requested_service_objective_name, elastic_pool_name, requested_service_objective_id, tags)
          database = Azure::ARM::SQL::Models::Database.new
          database.location = location
          database.edition = edition unless edition.nil?
          database.collation = collation unless collation.nil?
          database.create_mode = create_mode unless create_mode.nil?
          database.max_size_bytes = max_size_bytes unless max_size_bytes.nil?
          database.elastic_pool_name = elastic_pool_name unless elastic_pool_name.nil?
          database.source_database_id = source_database_id unless source_database_id.nil?
          database.requested_service_objective_id = requested_service_objective_id unless requested_service_objective_id.nil?
          database.requested_service_objective_name = requested_service_objective_name unless requested_service_objective_name.nil?
          database.tags = tags
          database
        end
      end

      # Mock class for Sql Database Request
      class Mock
        def create_or_update_database(*)
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
