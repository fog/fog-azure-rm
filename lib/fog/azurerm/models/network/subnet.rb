module Fog
  module Network
    class AzureRM
      # Subnet model for Network Service
      class Subnet < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :virtual_network_name
        attribute :properties
        attribute :addressPrefix
        attribute :networkSecurityGroupId
        attribute :routeTableId
        attribute :ipConfigurations

        def save
          requires :name
          requires :resource_group
          requires :virtual_network_name
          puts "Creating Subnet: #{name}..."
          service.create_subnet(resource_group, virtual_network_name, name, addressPrefix)
          puts "Subnet #{name} created successfully."
        end

        def destroy
          puts "Deleting Subnet: #{name}..."
          service.delete_subnet(resource_group, virtual_network_name, name)
          puts "Subnet #{name} deleted successfully."
        end
      end
    end
  end
end
