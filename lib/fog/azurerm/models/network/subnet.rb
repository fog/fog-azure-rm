module Fog
  module Network
    class AzureRM
      # Subnet model for Network Service
      class Subnet < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :virtual_network_name
        attribute :addressPrefix
        attribute :networkSecurityGroupId
        attribute :routeTableId
        attribute :ipConfigurations

        def self.parse(subnet)
          hash = {}
          hash['id'] = subnet['id']
          hash['name'] = subnet['name']
          hash['resource_group'] = subnet['id'].split('/')[4]
          hash['virtual_network_name'] = subnet['id'].split('/')[8]
          hash['addressPrefix'] = subnet['properties']['addressPrefix']
          hash['networkSecurityGroupId'] = subnet['properties']['networkSecurityGroup']['id'] unless subnet['properties']['networkSecurityGroup'].nil?
          hash['routeTableId'] = subnet['properties']['routeTable']['id'] unless subnet['properties']['routeTable'].nil?
          hash['ipConfigurations'] = subnet['properties']['ipConfigurations'] unless subnet['properties']['ipConfigurations'].nil?
          hash
        end

        def save
          requires :name
          requires :resource_group
          requires :virtual_network_name
          subnet = service.create_subnet(resource_group, virtual_network_name, name, addressPrefix)
          merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end

        def destroy
          service.delete_subnet(resource_group, virtual_network_name, name)
        end
      end
    end
  end
end
