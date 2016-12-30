module Fog
  module Sql
    class AzureRM
      # Sql Server Collection for Server Service
      class SqlServers < Fog::Collection
        attribute :resource_group
        model Fog::Sql::AzureRM::SqlServer

        def all
          requires :resource_group

          servers = []
          service.list_sql_servers(resource_group).each do |server|
            servers << Fog::Sql::AzureRM::SqlServer.parse(server)
          end
          load(servers)
        end

        def get(resource_group, server_name)
          server = service.get_sql_server(resource_group, server_name)
          server_fog = Fog::Sql::AzureRM::SqlServer.new(service: service)
          server_fog.merge_attributes(Fog::Sql::AzureRM::SqlServer.parse(server))
        end

        def check_sql_server_exists?(resource_group, server_name)
          service.check_sql_server_exists?(resource_group, server_name)
        end
      end
    end
  end
end
