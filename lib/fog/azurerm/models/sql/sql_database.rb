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
          database_hash = {}

          database_hash['id'] = database['id']
          database_hash['type'] = database['type']
          database_hash['name'] = database['name']
          database_hash['resource_group'] = get_resource_group_from_id(database['id'])
          database_hash['location'] = database['location']
          database_hash['edition'] = database['properties']['edition']
          database_hash['elastic_pool_name'] = database['elasticPoolName']
          database_hash['collation'] = database['properties']['collation']
          database_hash['create_mode'] = database['properties']['createMode']
          database_hash['database_id'] = database['properties']['databaseId']
          database_hash['server_name'] = get_server_name_from_id(database['id'])
          database_hash['creation_date'] = database['properties']['creationDate']
          database_hash['max_size_bytes'] = database['properties']['maxSizeBytes']
          database_hash['source_database_id'] = database['properties']['sourceDatabaseId']
          database_hash['restore_point_in_time'] = database['properties']['restorePointInTime']
          database_hash['earliest_restore_date'] = database['properties']['earliestRestoreDate']
          database_hash['service_level_objective'] = database['properties']['serviceLevelObjective']
          database_hash['default_secondary_location'] = database['properties']['defaultSecondaryLocation']
          database_hash['source_database_deletion_date'] = database['properties']['sourceDatabaseDeletionDate']
          database_hash['requested_service_objective_id'] = database['properties']['requestedServiceObjectiveId']
          database_hash['requested_service_objective_name'] = database['properties']['requestedServiceObjectiveName']
          database_hash['current_service_level_objective_id'] = database['properties']['currentServiceLevelObjectiveId']

          database_hash
        end

        def save
          requires :resource_group, :server_name, :name, :location
          sql_database = service.create_or_update_database(database_params_hash)
          merge_attributes(Fog::Sql::AzureRM::SqlDatabase.parse(sql_database))
        end

        def destroy
          service.delete_database(resource_group, server_name, name)
        end

        private

        def database_params_hash
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
