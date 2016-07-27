module Fog
  module Network
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for virtual network.
      class VirtualNetwork < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :dns_servers
        attribute :subnets
        attribute :address_prefixes

        def self.parse(vnet)
          hash = {}
          hash['id'] = vnet['id']
          hash['name'] = vnet['name']
          hash['resource_group'] = get_resource_group_from_id(vnet['id'])
          hash['location'] = vnet['location']
          hash['dns_servers'] = vnet['properties']['dhcpOptions']['dnsServers'] unless vnet['properties']['dhcpOptions'].nil?
          hash['address_prefixes'] = vnet['properties']['addressSpace']['addressPrefixes'] unless vnet['properties']['addressSpace']['addressPrefixes'].nil?

          subnets = []
          vnet['properties']['subnets'].each do |subnet|
            subnet_object = Fog::Network::AzureRM::Subnet.new
            subnets.push(subnet_object.merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet)))
          end
          hash['subnets'] = subnets
          hash
        end

        def save
          requires :name
          requires :location
          requires :resource_group
          validate_subnets(subnets) unless subnets.nil?

          vnet = service.create_virtual_network(resource_group, name, location, dns_servers, subnets, address_prefixes)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(vnet))
        end

        def destroy
          service.delete_virtual_network(resource_group, name)
        end

        private

        def validate_subnets(subnets)
          if subnets.is_a?(Array)
            subnets.each do |subnet|
              if subnet.is_a?(Hash)
                validate_params([:name], subnet)
              else
                raise(ArgumentError, ':subnets must be an Array of Hashes')
              end
            end
          else
            raise(ArgumentError, ':subnets must be an Array')
          end
        end
      end
    end
  end
end
