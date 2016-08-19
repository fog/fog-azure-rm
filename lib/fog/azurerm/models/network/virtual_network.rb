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
          hash['id'] = vnet.id
          hash['name'] = vnet.name
          hash['resource_group'] = get_resource_from_resource_id(vnet.id, RESOURCE_GROUP_NAME)
          hash['location'] = vnet.location
          hash['dns_servers'] = vnet.dhcp_options.dns_servers unless vnet.dhcp_options.nil?
          hash['address_prefixes'] = vnet.address_space.address_prefixes unless vnet.address_space.address_prefixes.nil?

          subnets = []
          vnet.subnets.each do |subnet|
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
          validate_subnets!(subnets) unless subnets.nil?

          virtual_network = service.create_or_update_virtual_network(resource_group, name, location, dns_servers, subnets, address_prefixes)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def add_dns_servers(dns_servers_list)
          virtual_network = service.add_dns_servers_in_virtual_network(resource_group, name, dns_servers_list)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def remove_dns_servers(dns_servers_list)
          virtual_network = service.remove_dns_servers_from_virtual_network(resource_group, name, dns_servers_list)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def add_address_prefixes(address_prefixes_list)
          virtual_network = service.add_address_prefixes_in_virtual_network(resource_group, name, address_prefixes_list)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def remove_address_prefixes(address_prefixes_list)
          virtual_network = service.remove_address_prefixes_from_virtual_network(resource_group, name, address_prefixes_list)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def add_subnets(subnets_list)
          validate_subnets!(subnets_list)
          virtual_network = service.add_subnets_in_virtual_network(resource_group, name, subnets_list)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def remove_subnets(subnet_names_list)
          virtual_network = service.remove_subnets_from_virtual_network(resource_group, name, subnet_names_list)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def update(vnet_hash)
          raise('Provided hash can not be empty.') if vnet_hash.empty? || vnet_hash.nil?
          validate_update_attributes!(vnet_hash)
          merge_attributes(vnet_hash)
          virtual_network = service.create_or_update_virtual_network(resource_group, name, location, dns_servers, subnets, address_prefixes)
          merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def destroy
          service.delete_virtual_network(resource_group, name)
        end

        private

        def validate_update_attributes!(vnet_hash)
          forbidden_attributes = [:id, :name, :location, :resource_group]
          invalid_attributes = forbidden_attributes & vnet_hash.keys
          raise "#{invalid_attributes.join(', ')} cannot be changed." if invalid_attributes.any?
          validate_subnets!(vnet_hash[:subnets]) if vnet_hash.key?(:subnets)
        end

        def validate_subnets!(subnets)
          raise ':subnets must be an Array' unless subnets.is_a?(Array)
          raise ':subnets must not be an empty Array' if subnets.empty?

          subnets.each do |subnet|
            raise ':subnets must be an Array of Hashes' unless subnet.is_a?(Hash)
            validate_params([:name, :address_prefix], subnet)
          end
        end
      end
    end
  end
end
