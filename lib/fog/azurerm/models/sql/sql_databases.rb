module Fog
  module Sql
    class AzureRM
      # Sql Server Collection for Database Service
      class SqlDatabases < Fog::Collection
        attribute :resource_group
        attribute :server_name
        model Fog::Sql::AzureRM::SqlDatabase

        def all
          requires :resource_group, :server_name

          databases = []
          service.list_databases(resource_group, server_name).each do |database|
            databases << Fog::Sql::AzureRM::SqlDatabase.parse(database)
          end
          load(databases)
        end

        def get(resource_group, server_name, name)
          database = service.get_database(resource_group, server_name, name)
          database_fog = Fog::Sql::AzureRM::SqlDatabase.new(service: service)
          database_fog.merge_attributes(Fog::Sql::AzureRM::SqlDatabase.parse(database))
        end

        def check_database_exists?(resource_group, server_name, name)
          service.check_database_exists?(resource_group, server_name, name)
        end
      end
    end
  end
end
