module Fog
  module Resources
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for tags.
      class Tag < Fog::Model
        attribute :resource_id
        attribute :tag_name
        attribute :tag_value
        attribute :name
        attribute :type
        attribute :location
        attribute :tags

        def self.parse(resource)
          hash = {}
          hash['resource_id'] = resource['id']
          hash['name'] = resource['name']
          hash['type'] = resource['type']
          hash['location'] = resource['location']
          hash['tags'] = resource['tags']
          hash
        end

        def save
          requires :resource_id, :tag_name, :tag_value
          tag = service.tag_resource(resource_id, tag_name, tag_value)
          merge_attributes(Fog::Resources::AzureRM::Tag.parse(tag))
        end

        def destroy(tag_name, tag_value)
          service.delete_resource_tag(resource_id, tag_name, tag_value)
        end
      end
    end
  end
end
