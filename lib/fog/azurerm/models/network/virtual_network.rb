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
        attribute :resource_group
        attribute :properties

        def save
          requires :name
          requires :location
          requires :resource_group
          Fog::Logger.debug "Creating Virtual Network: #{name}..."
          service.create_virtual_network(name, location, resource_group, dns_list, subnet_address_list, network_address_list)
          Fog::Logger.debug "Virtual Network #{name} created successfully."
        end

        def destroy
          Fog::Logger.debug "Deleting Virtual Network: #{name}..."
          service.delete_virtual_network(resource_group, name)
          Fog::Logger.debug "Virtual Network #{name} deleted successfully."
        end
      end
    end
  end
end
