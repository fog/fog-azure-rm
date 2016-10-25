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
        attribute :start_ip
        attribute :end_ip
        attribute :server_name

        def self.parse(firewall)
          {
            id: firewall['id'],
            type: firewall['type'],
            name: firewall['name'],
            location: firewall['location'],
            resource_group: get_resource_group_from_id(firewall['id']),
            server_name: get_server_name_from_id(firewall['id']),
            start_ip: firewall['properties']['startIpAddress'],
            end_ip: firewall['properties']['endIpAddress']
          }
        end

        def save
          requires :resource_group, :server_name, :name, :start_ip, :end_ip
          firewall_rule = service.create_or_update_firewall_rule(firewall_params)
          merge_attributes(FirewallRule.parse(firewall_rule))
        end

        def destroy
          service.delete_firewall_rule(resource_group, server_name, name)
        end

        private

        def firewall_params
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
