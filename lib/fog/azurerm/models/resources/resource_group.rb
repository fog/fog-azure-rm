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
          service.create_resource_group(name, location)
        end

        def destroy
          service.delete_resource_group(name)
        end
      end
    end
  end
end
