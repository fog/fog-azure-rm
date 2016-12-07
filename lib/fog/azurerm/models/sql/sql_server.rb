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
        attribute :administrator_login, aliases: %w(administratorLogin)
        attribute :administrator_login_password, aliases: %w(administratorLoginPassword)
        attribute :fully_qualified_domain_name, aliases: %w(fullyQualifiedDomainName)

        def self.parse(server_obj)
          data = {}
          data['resource_group'] = get_resource_group_from_id(server_obj['id'])
          if server_obj.is_a? Hash
            server_obj.each do |k, v|
              if k == 'properties'
                v.each do |j, l|
                  data[j] = l
                end
              else
                data[k] = v
              end
            end
          else
            puts 'Object is not a hash. Parsing SQL Server object failed.'
          end

          data
        end

        def save
          requires :name, :resource_group, :location, :version, :administrator_login, :administrator_login_password
          sql_server = service.create_or_update_sql_server(format_sql_server_params)
          merge_attributes(Fog::Sql::AzureRM::SqlServer.parse(sql_server))
        end

        def destroy
          service.delete_sql_server(resource_group, name)
        end

        private

        def format_sql_server_params
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
