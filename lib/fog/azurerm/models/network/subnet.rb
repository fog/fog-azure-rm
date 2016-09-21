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
          subnet_hash = {}
          subnet_hash['id'] = subnet.id
          subnet_hash['name'] = subnet.name
          subnet_hash['resource_group'] = get_resource_group_from_id(subnet.id)
          subnet_hash['virtual_network_name'] = get_virtual_network_from_id(subnet.id)
          subnet_hash['address_prefix'] = subnet.address_prefix
          subnet_hash['network_security_group_id'] = nil
          subnet_hash['network_security_group_id'] = subnet.network_security_group.id unless subnet.network_security_group.nil?
          subnet_hash['route_table_id'] = nil
          subnet_hash['route_table_id'] = subnet.route_table.id unless subnet.route_table.nil?
          subnet_hash['ip_configurations_ids'] = subnet.ip_configurations.map(&:id) unless subnet.ip_configurations.nil?
          subnet_hash
        end

        def save
          requires :name, :resource_group, :virtual_network_name, :address_prefix
          subnet = service.create_subnet(resource_group, name, virtual_network_name, address_prefix, network_security_group_id, route_table_id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def attach_network_security_group(network_security_group_id)
          subnet = service.attach_network_security_group_to_subnet(resource_group, name, virtual_network_name, address_prefix, route_table_id, network_security_group_id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def detach_network_security_group
          subnet = service.detach_network_security_group_from_subnet(resource_group, name, virtual_network_name, address_prefix, route_table_id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def attach_route_table(route_table_id)
          subnet = service.attach_route_table_to_subnet(resource_group, name, virtual_network_name, address_prefix, network_security_group_id, route_table_id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def detach_route_table
          subnet = service.detach_route_table_from_subnet(resource_group, name, virtual_network_name, address_prefix, network_security_group_id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def get_available_ipaddress_count
          service.get_available_ipaddress_count(name, address_prefix, ip_configurations_ids)
        end

        def destroy
          service.delete_subnet(resource_group, name, virtual_network_name)
        end
      end
    end
  end
end
