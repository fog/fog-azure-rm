module Fog
  module Sql
    class AzureRM
      # Sql Server model for Server Service
      class SqlServer < Fog::Model
        identity :name
        attribute :id
        attribute :type
        attribute :resource_group
        attribute :location
        attribute :version
        attribute :state
        attribute :administrator_login
        attribute :administrator_login_password
        attribute :fully_qualified_domain_name

        def self.parse(server)
          {
            id: server['id'],
            type: server['type'],
            name: server['name'],
            location: server['location'],
            state: server['properties']['state'],
            version: server['properties']['version'],
            resource_group: get_resource_group_from_id(server['id']),
            administrator_login: server['properties']['administratorLogin'],
            administrator_login_password: server['properties']['administratorLoginPassword'],
            fully_qualified_domain_name: server['properties']['fullyQualifiedDomainName']
          }
        end

        def save
          requires :name, :resource_group, :location, :version, :administrator_login, :administrator_login_password
          sql_server = service.create_or_update_sql_server(database_params)
          merge_attributes(Fog::Sql::AzureRM::SqlServer.parse(sql_server))
        end

        def destroy
          service.delete_sql_server(resource_group, name)
        end

        private

        def database_params
          {
            resource_group: resource_group,
            name: name,
            version: version,
            location: location,
            administrator_login: administrator_login,
            administrator_login_password: administrator_login_password
          }
        end
      end
    end
  end
end
