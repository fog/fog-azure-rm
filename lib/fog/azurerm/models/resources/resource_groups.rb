module Fog
  module Resources
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check name availability for resource groups.
      class ResourceGroups < Fog::Collection
        model ResourceGroup

        def all
          resource_groups = []
          service.list_resource_groups.each do |resource_group|
            resource_groups.push(ResourceGroup.parse(resource_group))
          end
          load(resource_groups)
        end

        def get(resource_group_name)
          resource_group = service.get_resource_group(resource_group_name)
          resource_group_object = ResourceGroup.new(service: service)
          resource_group_object.merge_attributes(ResourceGroup.parse(resource_group))
        end
      end
    end
  end
end
