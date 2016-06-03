module Fog
  module Network
    class AzureRM
      # Subnet model for Network Service
      class Subnet < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :virtual_network_name
        attribute :address_prefix
        attribute :network_security_group_id
        attribute :route_table_id
        attribute :ip_configurations_ids

        def self.parse(subnet)
          hash = {}
          hash['id'] = subnet['id']
          hash['name'] = subnet['name']
          hash['resource_group'] = subnet['id'].split('/')[4]
          hash['virtual_network_name'] = subnet['id'].split('/')[8]
          hash['address_prefix'] = subnet['properties']['addressPrefix']
          hash['network_security_group_id'] = subnet['properties']['networkSecurityGroup']['id'] unless subnet['properties']['networkSecurityGroup'].nil?
          hash['route_table_id'] = subnet['properties']['routeTable']['id'] unless subnet['properties']['routeTable'].nil?
          hash['ip_configurations_ids'] = subnet['properties']['ipConfigurations'].map { |item| item['id'] } unless subnet['properties']['ipConfigurations'].nil?
          hash
        end

        def save
          requires :name
          requires :resource_group
          requires :virtual_network_name
          subnet = service.create_subnet(resource_group, name, virtual_network_name, address_prefix)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def destroy
          service.delete_subnet(resource_group, name, virtual_network_name)
        end
      end
    end
  end
end
