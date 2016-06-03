require 'fog/core/collection'
require 'fog/azurerm/models/resources/resource_group'

module Fog
  module Resources
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check name availability for resource groups.
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
