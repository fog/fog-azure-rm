module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_resource_tag(resource_id, tag_name, tag_value)
          resource_group_name = get_resource_from_resource_id(resource_id, RESOURCE_GROUP_NAME)
          resource_provider_namespace = get_resource_from_resource_id(resource_id, RESOURCE_PROVIDER_NAMESPACE)
          resource_type = get_resource_from_resource_id(resource_id, RESOURCE_TYPE)
          resource_name = get_resource_from_resource_id(resource_id, RESOURCE_NAME)

          Fog::Logger.debug "Deleting Tag #{tag_name} from Resource #{resource_name}"
          begin
            resource = @rmc.resources.get(resource_group_name, resource_provider_namespace, '', resource_type, resource_name, API_VERSION)

            if resource.tags.key?(tag_name)
              resource.tags.delete_if { |key, value| key == tag_name && value == tag_value }
            end
            @rmc.resources.create_or_update(resource_group_name, resource_provider_namespace, '', resource_type, resource_name, API_VERSION, resource)
            Fog::Logger.debug "Tag #{tag_name} deleted successfully from Resource #{resource_name}"
            true
          rescue  MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_resource_tag(_resource_id, tag_name, _tag_value)
          Fog::Logger.debug "Tag #{tag_name} deleted successfully from Resource your-resource-name"
          true
        end
      end
    end
  end
end
