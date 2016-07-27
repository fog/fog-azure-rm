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
          hash['resource_group'] = get_resource_group_from_id(subnet['id'])
          hash['virtual_network_name'] = get_virtual_network_from_id(subnet['id'])
          hash['address_prefix'] = subnet['properties']['addressPrefix']
          hash['network_security_group_id'] = if subnet['properties']['networkSecurityGroup'].nil?
                                                nil
                                              else
                                                subnet['properties']['networkSecurityGroup']['id']
                                              end
          hash['route_table_id'] = if subnet['properties']['routeTable'].nil?
                                     nil
                                   else
                                     subnet['properties']['routeTable']['id']
                                   end
          hash['ip_configurations_ids'] = subnet['properties']['ipConfigurations'].map { |item| item['id'] } unless subnet['properties']['ipConfigurations'].nil?
          hash
        end

        def save
          requires :name
          requires :resource_group
          requires :virtual_network_name
          subnet = service.create_subnet(resource_group, name, virtual_network_name, address_prefix, network_security_group_id, route_table_id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def attach_network_security_group(id)
          subnet = service.attach_network_security_group_with_subnet(resource_group, name, virtual_network_name, address_prefix, route_table_id, id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def detach_network_security_group
          subnet = service.detach_network_security_group_from_subnet(resource_group, name, virtual_network_name, address_prefix, route_table_id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def attach_route_table(id)
          subnet = service.attach_route_table_with_subnet(resource_group, name, virtual_network_name, address_prefix, network_security_group_id, id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def detach_route_table
          subnet = service.detach_route_table_from_subnet(resource_group, name, virtual_network_name, address_prefix, network_security_group_id)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def destroy
          service.delete_subnet(resource_group, name, virtual_network_name)
        end
      end
    end
  end
end
