module Fog
  module Network
    class AzureRM
      # NetworkInterface model class for Network Service
      class NetworkInterface < Fog::Model
        identity :name
        attribute :location
        attribute :resource_group
        attribute :subnet_id
        attribute :ip_configurations_name
        attribute :private_ip_allocation_method
        attribute :properties

        def save
          requires :name
          requires :location
          requires :resource_group
          requires :subnet_id
          requires :ip_configurations_name
          requires :private_ip_allocation_method

          Fog::Logger.debug "Creating Network Interface Card: #{name}..."
          service.create_network_interface(name, location, resource_group, subnet_id, ip_configurations_name, private_ip_allocation_method)
          Fog::Logger.debug "Network Interface #{name} created successfully."
        end

        def destroy
          service.delete_network_interface(resource_group, name)
        end
      end
    end
  end
end
