module Fog
  module Sql
    class AzureRM
      # Real class for Sql Database Request
      class Real
        def create_or_update_database(database_hash)
          msg = "Creating SQL Database: #{database_hash[:name]}."
          Fog::Logger.debug msg
          resource_url = "#{resource_manager_endpoint_url}/subscriptions/#{@subscription_id}/resourceGroups/#{database_hash[:resource_group]}/providers/Microsoft.Sql/servers/#{database_hash[:server_name]}/databases/#{database_hash[:name]}?api-version=2014-04-01-preview"
          request_parameters = get_database_parameters(database_hash[:location], database_hash[:create_mode], database_hash[:edition], database_hash[:source_database_id], database_hash[:collation], database_hash[:max_size_bytes], database_hash[:requested_service_objective_name], database_hash[:restore_point_in_time], database_hash[:source_database_deletion_date], database_hash[:elastic_pool_name], database_hash[:requested_service_objective_id])
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.put(
              resource_url,
              request_parameters.to_json,
              accept: :json,
              content_type: :json,
              authorization: token
            )
          rescue RestClient::Exception => e
            raise ::JSON.parse(e.response)['message']
          end
          Fog::Logger.debug "SQL Database: #{database_hash[:name]} created successfully."
          ::JSON.parse(response)
        end

        private

        def get_database_parameters(location, create_mode, edition, source_database_id, collation, max_size_bytes, requested_service_objective_name, restore_point_in_time, source_database_deletion_date, elastic_pool_name, requested_service_objective_id)
          parameters = {}
          properties = {}

          properties['edition'] = edition unless edition.nil?
          properties['collation'] = collation unless collation.nil?
          properties['createMode'] = create_mode unless create_mode.nil?
          properties['maxSizeBytes'] = max_size_bytes unless max_size_bytes.nil?
          properties['elasticPoolName'] = elastic_pool_name unless elastic_pool_name.nil?
          properties['sourceDatabaseId'] = source_database_id unless source_database_id.nil?
          properties['restorePointInTime'] = restore_point_in_time unless restore_point_in_time.nil?
          properties['sourceDatabaseDeletionDate'] = source_database_deletion_date unless source_database_deletion_date.nil?
          properties['requestedServiceObjectiveId'] = requested_service_objective_id unless requested_service_objective_id.nil?
          properties['requestedServiceObjectiveName'] = requested_service_objective_name unless requested_service_objective_name.nil?

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
