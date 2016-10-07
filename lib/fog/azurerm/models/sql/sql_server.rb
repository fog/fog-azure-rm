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
          server_hash = {}
          server_hash['id'] = server['id']
          server_hash['type'] = server['type']
          server_hash['name'] = server['name']
          server_hash['resource_group'] = get_resource_group_from_id(server['id'])
          server_hash['location'] = server['location']

          server_hash['state'] = server['properties']['state']
          server_hash['version'] = server['properties']['version']
          server_hash['administrator_login'] = server['properties']['administratorLogin']
          server_hash['administrator_login_password'] = server['properties']['administratorLoginPassword']
          server_hash['fully_qualified_domain_name'] = server['properties']['fullyQualifiedDomainName']

          server_hash
        end

        def save
          requires :name, :resource_group, :location, :version, :administrator_login, :administrator_login_password
          sql_server = service.create_or_update_sql_server(server_params_hash)
          merge_attributes(Fog::Sql::AzureRM::SqlServer.parse(sql_server))
        end

        def destroy
          service.delete_sql_server(resource_group, name)
        end

        private
        def server_params_hash
          {
            resource_group: resource_group,
            name: name,
            version: version,
            location: location,
            administrator_login: administrator_login,
            administrator_login_password: administrator_login_password,
          }
        end
      end
    end
  end
end
