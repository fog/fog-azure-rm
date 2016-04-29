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
          virtual_network = service.create_virtual_network(name, location, resource_group, dns_list, subnet_address_list, network_address_list)
          Fog::Logger.debug "Virtual Network #{name} created successfully."
          virtual_network
        end

        def destroy
          service.delete_virtual_network(resource_group, name)
        end
      end
    end
  end
end
