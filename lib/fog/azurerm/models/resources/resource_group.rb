module Fog
  module Resources
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for resource group.
      class ResourceGroup < Fog::Model
        identity :name
        attribute :id
        attribute :location

        def self.parse(resource_group)
          hash = {}
          hash['id'] = resource_group.id
          hash['name'] = resource_group.name
          hash['location'] = resource_group.location
          hash
        end

        def save
          requires :name
          requires :location
          resource_group = service.create_resource_group(name, location)
          merge_attributes(Fog::Resources::AzureRM::ResourceGroup.parse(resource_group))
        end

        def destroy
          service.delete_resource_group(name)
        end
      end
    end
  end
end
