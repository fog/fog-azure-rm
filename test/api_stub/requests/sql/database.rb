module ApiStub
  module Requests
    module Sql
      # Mock class for Database
      class SqlDatabase
        def self.create_database_response(sql_manager_client)
          body = '{
            "name" : "{database-name}",
            "server_name" : "{server-name}",
            "location" : "{database-location}",
            "properties" : {
              "createMode" : "{creation-mode}",
              "sourceDatabaseId" : "{source-database-id}",
              "edition" : "{database-edition}",
              "collation" : "{collation-name}",
              "maxSizeBytes" : "{max-database-size}",
              "requestedServiceObjectiveId" : "{requested-service-id}",
              "requestedServiceObjectiveName" : "{requested-service-id}",
              "restorePointInTime" : "{restore-time}",
              "sourceDatabaseDeletionDate" : "{source-deletion-date}",
              "elasticPoolName" : "{elastic-pool-name}"
            }
          }'
          database_mapper = Azure::ARM::SQL::Models::Database.mapper
          sql_manager_client.deserialize(database_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.list_database_response(sql_manager_client)
          body = '{
            "value": [{
              "name" : "{database-name}",
              "server_name" : "{server-name}",
              "location" : "{database-location}",
              "properties" : {
                "createMode" : "{creation-mode}",
                "sourceDatabaseId" : "{source-database-id}",
                "edition" : "{database-edition}",
                "collation" : "{collation-name}",
                "maxSizeBytes" : "{max-database-size}",
                "requestedServiceObjectiveId" : "{requested-service-id}",
                "requestedServiceObjectiveName" : "{requested-service-id}",
                "restorePointInTime" : "{restore-time}",
                "sourceDatabaseDeletionDate" : "{source-deletion-date}",
                "elasticPoolName" : "{elastic-pool-name}"
              }
            }]
          }'
          database_mapper = Azure::ARM::SQL::Models::DatabaseListResult.mapper
          sql_manager_client.deserialize(database_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.database_hash
          {
            resource_group: 'resource_group',
            server_name: 'server_name',
            name: 'name',
            location: 'location',
            create_mode: 'create_mode',
            edition: 'edition',
            source_database_id: 'source_database_id',
            collation: 'collation',
            max_size_bytes: 'max_size_bytes',
            requested_service_objective_name: 'requested_service_objective_name',
            elastic_pool_name: 'elastic_pool_name',
            requested_service_objective_id: 'requested_service_objective_id'
          }
        end
      end
    end
  end
end
