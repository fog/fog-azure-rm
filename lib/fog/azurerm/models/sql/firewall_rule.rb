module Fog
  module Sql
    class AzureRM
      # Sql Server model for Server Firewall Rule Service
      class FirewallRule < Fog::Model
        identity :name
        attribute :id
        attribute :type
        attribute :resource_group
        attribute :location
        attribute :start_ip, aliases: %w(startIpAddress)
        attribute :end_ip, aliases: %w(endIpAddress)
        attribute :server_name

        def self.parse(firewall)
          data = {}
          if firewall.is_a? Hash
            firewall.each do |k, v|
              if k == 'properties'
                v.each do |j, l|
                  data[j] = l
                end
              else
                data[k] = v
              end
            end
            data['resource_group'] = get_resource_group_from_id(firewall['id'])
            data['server_name'] = get_resource_from_resource_id(firewall['id'], 8)
          else
            raise 'Object is not a hash. Parsing SQL Server firewall object failed.'
          end

          data
        end

        def save
          requires :resource_group, :server_name, :name, :start_ip, :end_ip
          firewall_rule = service.create_or_update_firewall_rule(format_firewall_params)
          merge_attributes(Fog::Sql::AzureRM::FirewallRule.parse(firewall_rule))
        end

        def destroy
          service.delete_firewall_rule(resource_group, server_name, name)
        end

        private

        def format_firewall_params
          {
            resource_group: resource_group,
            server_name: server_name,
            name: name,
            start_ip: start_ip,
            end_ip: end_ip
          }
        end
      end
    end
  end
end
