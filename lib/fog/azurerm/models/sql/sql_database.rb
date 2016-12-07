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
        attribute :edition
        attribute :location
        attribute :create_mode, aliases: %w(createMode)
        attribute :creation_date, aliases: %w(creationDate)
        attribute :current_service_level_objective_id, aliases: %w(currentServiceLevelObjectiveId)
        attribute :database_id, aliases: %w(databaseId)
        attribute :default_secondary_location, aliases: %w(defaultSecondaryLocation)
        attribute :earliest_restore_date, aliases: %w(earliestRestoreDate)
        attribute :elastic_pool_name, aliases: %w(elasticPoolName)
        attribute :max_size_bytes, aliases: %w(maxSizeBytes)
        attribute :requested_service_objective_id, aliases: %w(requestedServiceObjectiveId)
        attribute :requested_service_objective_name, aliases: %w(requestedServiceObjectiveName)
        attribute :restore_point_in_time, aliases: %w(restorePointInTime)
        attribute :service_level_objective, aliases: %w(serviceLevelObjective)
        attribute :source_database_id, aliases: %w(sourceDatabaseId)
        attribute :source_database_deletion_date, aliases: %w(sourceDatabaseDeletionDate)

        def self.parse(database)
          data = {}
          data['resource_group'] = get_resource_group_from_id(database['id'])
          data['server_name'] = get_resource_from_resource_id(database['id'], 8)

          if database.is_a? Hash
            database.each do |k, v|
              if k == 'properties'
                v.each do |j, l|
                  data[j] = l
                end
              else
                data[k] = v
              end
            end
          else
            raise 'Object is not a hash. Parsing SQL Database object failed.'
          end

          data
        end

        def save
          requires :resource_group, :server_name, :name, :location
          sql_database = service.create_or_update_database(format_database_params)
          merge_attributes(Fog::Sql::AzureRM::SqlDatabase.parse(sql_database))
        end

        def destroy
          service.delete_database(resource_group, server_name, name)
        end

        private

        def format_database_params
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
