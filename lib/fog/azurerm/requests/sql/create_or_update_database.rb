module Fog
  module Sql
    class AzureRM
      # Real class for Sql Database Request
      class Real
        def create_or_update_database(database_hash)
          msg = "Creating SQL Database: #{database_hash[:name]}."
          Fog::Logger.debug msg
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{database_hash[:resource_group]}/providers/Microsoft.Sql/servers/#{database_hash[:server_name]}/databases/#{database_hash[:name]}?api-version=2014-04-01-preview"
          request_parameters = format_request_parameters(database_hash[:location], database_hash[:create_mode], database_hash[:edition], database_hash[:source_database_id], database_hash[:collation], database_hash[:max_size_bytes], database_hash[:requested_service_objective_name], database_hash[:restore_point_in_time], database_hash[:source_database_deletion_date], database_hash[:elastic_pool_name])
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.put(
              resource_url,
              request_parameters.to_json,
              accept: :json,
              content_type: :json,
              authorization: token
            )

          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, JSON.parse(e.response)['message'])
          end
          Fog::Logger.debug "SQL Database: #{database_hash[:name]} created successfully."
          JSON.parse(response)
        end

        private
        def format_request_parameters(location, create_mode, edition, source_database_id, collation, max_size_bytes, requested_service_objective_name, restore_point_in_time, source_database_deletion_date, elastic_pool_name)
          parameters = {}
          properties = {}

          properties['edition'] = edition
          properties['collation'] = collation
          properties['createMode'] = create_mode
          properties['maxSizeBytes'] = max_size_bytes
          properties['elasticPoolName'] = elastic_pool_name
          properties['sourceDatabaseId'] = source_database_id
          properties['restorePointInTime'] = restore_point_in_time
          properties['sourceDatabaseDeletionDate'] = source_database_deletion_date
          properties['requestedServiceObjectiveName'] = requested_service_objective_name

          parameters['tags'] = {}
          parameters['location'] = location
          parameters['properties'] = properties

          parameters
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
