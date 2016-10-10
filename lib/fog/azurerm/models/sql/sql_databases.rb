module Fog
  module Sql
    class AzureRM
      # Sql Server Collection for Database Service
      class SqlDatabases < Fog::Collection
        attribute :resource_group
        attribute :server_name
        model SqlDatabase

        def all
          requires :resource_group
          requires :server_name

          databases = []
          service.list_databases(resource_group, server_name).each do |database|
            databases << SqlDatabase.parse(database)
          end
          load(databases)
        end

        def get(resource_group, server_name, name)
          database = service.get_database(resource_group, server_name, name)
          database_obj = SqlDatabase.new(service: service)
          database_obj.merge_attributes(SqlDatabase.parse(database))
        end
      end
    end
  end
end
