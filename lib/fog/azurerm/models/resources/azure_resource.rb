module Fog
  module Resources
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for resources.
      class AzureResource < Fog::Model
        attribute :id
        attribute :name
        attribute :type
        attribute :location
        attribute :tags

        def self.parse(resource)
          hash = {}
          hash['id'] = resource.id
          hash['name'] = resource.name
          hash['type'] = resource.type
          hash['location'] = resource.location
          hash['tags'] = resource.tags
          hash
        end
      end
    end
  end
end
