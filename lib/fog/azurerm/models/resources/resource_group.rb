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
          puts "Creating Resource Group: #{name}."
          rg_properties = ::Azure::ARM::Resources::Models::ResourceGroup.new
          rg_properties.location = location
          promise = service.create_resource_group(name, rg_properties)
          result = promise.value!
          resource_group = result.body
          puts "Resource Group #{resource_group.name} created successfully."
        end

        def destroy
          puts "Deleting Resource Group: #{name}."
          promise = service.delete_resource_group(name)
          result = promise.value!
          resource_group = result.body
          puts "Resource Group #{name} deleted successfully."
        end
      end
    end
  end
end