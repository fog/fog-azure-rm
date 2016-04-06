module Fog
  module Network
    class AzureRM
      class VirtualNetwork < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :dns_list
        attribute :subnet_address_list
        attribute :network_address_list
        attribute :network_security_group
        attribute :resource_group

        def save
          requires :name
          requires :location
          requires :resource_group
          puts "Creating Virtual Network: #{name}..."
          service.create_virtual_network(name, location, resource_group, dns_list = nil, subnet_address_list = nil, network_address_list = nil, network_security_group = nil)
          puts "Virtual Network #{name} created successfully."
        end

        def destroy
          puts "Deleting Virtual Network: #{name}..."
          service.delete_virtual_network(resource_group, name)
          puts "Virtual Network #{name} deleted successfully."
        end
      end
    end
  end
end
