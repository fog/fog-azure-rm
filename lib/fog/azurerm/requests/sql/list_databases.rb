module Fog
  module Sql
    class AzureRM
      # Real class for Sql Database Request
      class Real
        def list_databases(resource_group, server_name)
          msg = "Listing Sql Databases in Resource Group: #{resource_group}."
          Fog::Logger.debug msg
          resource_url = "#{resource_manager_endpoint_url}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Sql/servers/#{server_name}/databases?api-version=2014-04-01-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
          rescue RestClient::Exception => e
            raise ::JSON.parse(e.response)['message']
          end
          Fog::Logger.debug "Sql Databases listed successfully in Resource Group: #{resource_group}"
          ::JSON.parse(response)['value']
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
