module Fog
  module Resources
    class AzureRM
      class ResourceGroup < Fog::Model
        identity :name
        attribute :id
        attribute :location

        def save
          requires :name
          requires :location
          Fog::Logger.debug "Creating Resource Group: #{name}."
          rg_properties = ::Azure::ARM::Resources::Models::ResourceGroup.new
          rg_properties.location = location
          service.create_resource_group(name, rg_properties)
          Fog::Logger.debug "Resource Group #{name} created successfully."
        end

        def destroy
          Fog::Logger.debug "Deleting Resource Group: #{name}."
          service.delete_resource_group(name)
          Fog::Logger.debug "Resource Group #{name} deleted successfully."
        end
      end
    end
  end
end
