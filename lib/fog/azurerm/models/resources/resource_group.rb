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
          resource_group = service.create_resource_group(name, location)
          merge_attributes(resource_group)
        end

        def destroy
          service.delete_resource_group(name)
        end
      end
    end
  end
end
