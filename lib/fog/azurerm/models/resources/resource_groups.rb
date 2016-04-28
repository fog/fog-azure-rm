require 'fog/core/collection'
require 'fog/azurerm/models/resources/resource_group'

module Fog
  module Resources
    class AzureRM
      class ResourceGroups < Fog::Collection
        model Fog::Resources::AzureRM::ResourceGroup

        def all
          resource_groups = []
          service.list_resource_groups.each do |rg|
            hash = {}
            rg.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = rg.instance_variable_get(var)
            end
            resource_groups << hash
          end
          load(resource_groups)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        end
      end
    end
  end
end
