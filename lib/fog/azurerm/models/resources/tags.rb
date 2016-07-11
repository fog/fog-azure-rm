require 'fog/core/collection'
require 'fog/azurerm/models/resources/tag'

module Fog
  module Resources
    class AzureRM
      # This class is giving implementation of all/list and get.
      class Tags < Fog::Collection
        model Fog::Resources::AzureRM::Tag
        attribute :tag_name
        attribute :tag_value

        def all
          requires :tag_name
          resources = []
          service.list_tagged_resources(tag_name, tag_value).each do |resource|
            resources << Fog::Resources::AzureRM::Tag.parse(resource)
          end
          load(resources)
        end

        def get(resource_id)
          all.find { |f| f.resource_id == resource_id }
        end
      end
    end
  end
end
