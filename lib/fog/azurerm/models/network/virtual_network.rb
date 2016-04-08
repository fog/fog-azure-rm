module Fog
  module Network
    class AzureRM
      class VirtualNetwork < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :addressPrefixes
        attribute :dnsServers
        attribute :subnets

        def save
          requires :name
          requires :location
          requires :resource_group
          puts "Creating Virtual Network: #{name}..."
          service.create_virtual_network(name, location, resource_group, dnsServers, subnets, addressPrefixes)
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
