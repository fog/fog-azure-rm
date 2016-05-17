require 'fog/core/collection'
require 'fog/azurerm/models/resources/resource_group'

module Fog
  module Resources
    class AzureRM
      class ResourceGroups < Fog::Collection
        model Fog::Resources::AzureRM::ResourceGroup

        def all
          load(service.list_resource_groups)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        end
      end
    end
  end
end
