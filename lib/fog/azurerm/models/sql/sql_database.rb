module Fog
  module Sql
    class AzureRM
      # Sql Database model for Database Service
      class SqlDatabase < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :server_name
        attribute :type
        attribute :collation
        attribute :create_mode
        attribute :creation_date
        attribute :current_service_level_objective_id
        attribute :database_id
        attribute :default_secondary_location
        attribute :edition
        attribute :earliest_restore_date
        attribute :elastic_pool_name
        attribute :location
        attribute :max_size_bytes
        attribute :requested_service_objective_id
        attribute :requested_service_objective_name
        attribute :restore_point_in_time
        attribute :service_level_objective
        attribute :source_database_id
        attribute :source_database_deletion_date

        def self.parse(database)
          sql_database = {}
          sql_database['id'] = database['id'] unless database['id'].nil?
          sql_database['type'] = database['type'] unless database['type'].nil?
          sql_database['name'] = database['name'] unless database['name'].nil?
          sql_database['location'] = database['location'] unless database['location'].nil?
          sql_database['elastic_pool_name'] = database['elasticPoolName']  unless database['elasticPoolName'].nil?
          unless database['id'].nil?
          sql_database['server_name']= get_server_name_from_id(database['id'])
          sql_database['resource_group']= get_resource_group_from_id(database['id'])
          end
          unless database['properties'].nil?
          sql_database['edition']= database['properties']['edition']
          sql_database['collation']= database['properties']['collation']
          sql_database['create_mode']= database['properties']['createMode']
          sql_database['database_id']= database['properties']['databaseId']
          sql_database['creation_date']= database['properties']['creationDate']
          sql_database['max_size_bytes']= database['properties']['maxSizeBytes']
          sql_database['source_database_id']= database['properties']['sourceDatabaseId']
          sql_database['restore_point_in_time']= database['properties']['restorePointInTime']
          sql_database['earliest_restore_date']= database['properties']['earliestRestoreDate']
          sql_database['service_level_objective']= database['properties']['serviceLevelObjective']
          sql_database['default_secondary_location']= database['properties']['defaultSecondaryLocation']
          sql_database['source_database_deletion_date']= database['properties']['sourceDatabaseDeletionDate']
          sql_database['requested_service_objective_id']= database['properties']['requestedServiceObjectiveId']
          sql_database['requested_service_objective_name']= database['properties']['requestedServiceObjectiveName']
          sql_database['current_service_level_objective_id']= database['properties']['currentServiceLevelObjectiveId']
          end
          sql_database
        end

        def save
          requires :resource_group, :server_name, :name, :location
          sql_database = service.create_or_update_database(database_params)
          merge_attributes(SqlDatabase.parse(sql_database))
        end

        def destroy
          service.delete_database(resource_group, server_name, name)
        end

        private

        def database_params
          {
            resource_group: resource_group,
            server_name: server_name,
            name: name,
            location: location,
            create_mode: create_mode,
            edition: edition,
            source_database_id: source_database_id,
            collation: collation,
            max_size_bytes: max_size_bytes,
            requested_service_objective_name: requested_service_objective_name,
            restore_point_in_time: restore_point_in_time,
            source_database_deletion_date: source_database_deletion_date,
            elastic_pool_name: elastic_pool_name,
            requested_service_objective_id: requested_service_objective_id
          }
        end
      end
    end
  end
end
