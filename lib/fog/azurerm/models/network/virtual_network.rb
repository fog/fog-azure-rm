module Fog
  module Network
    class AzureRM
      class VirtualNetwork < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :dns_list
        attribute :subnet_address_list
        attribute :network_address_list

        def self.parse(vnet)
          hash = {}
          hash['id'] = vnet['id']
          hash['name'] = vnet['name']
          hash['resource_group'] = vnet['id'].split('/')[4]
          hash['location'] = vnet['location']
          hash['dns_list'] = vnet['properties']['dhcpOptions']['dnsServers'].join(',') unless vnet['properties']['dhcpOptions'].nil?
          hash['network_address_list'] = vnet['properties']['addressSpace']['addressPrefixes'].join(',') unless vnet['properties']['addressSpace']['addressPrefixes'].nil?
          subnet_address_list = []
          vnet['properties']['subnets'].each do |subnet|
            subnet_address_list << subnet['properties']['addressPrefix']
          end
          hash['subnet_address_list'] = subnet_address_list.join(',')
          hash
        end

        def save
          requires :name
          requires :location
          requires :resource_group
          vnet = service.create_virtual_network(name, location, resource_group, dns_list, subnet_address_list, network_address_list)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(vnet))
        end

        def destroy
          service.delete_virtual_network(resource_group, name)
        end
      end
    end
  end
end
