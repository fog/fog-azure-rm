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
          Fog::Logger.debug "Creating Subnet: #{name}..."
          #puts "Creating Subnet: #{name}..."
          subnet = service.create_subnet(resource_group, virtual_network_name, name, addressPrefix)
          Fog::Logger.debug "Subnet #{name} created successfully."
          #puts "Subnet #{name} created successfully."
          subnet
        end

        def destroy
          service.delete_subnet(resource_group, virtual_network_name, name)
        end
      end
    end
  end
end
