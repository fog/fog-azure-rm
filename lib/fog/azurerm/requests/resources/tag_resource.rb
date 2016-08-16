module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def tag_resource(resource_id, tag_name, tag_value)
          resource_group_name = get_resource_from_resource_id(resource_id, RESOURCE_GROUP_NAME)
          resource_provider_namespace = get_resource_from_resource_id(resource_id, RESOURCE_PROVIDER_NAMESPACE)
          resource_type = get_resource_from_resource_id(resource_id, RESOURCE_TYPE)
          resource_name = get_resource_from_resource_id(resource_id, RESOURCE_NAME)
          parent_resource_id = ''

          Fog::Logger.debug "Creating Tag #{tag_name} for Resource #{resource_name}"
          begin
            promise = @rmc.resources.get(resource_group_name, resource_provider_namespace, parent_resource_id, resource_type, resource_name, API_VERSION)
            result = promise.value!
            resource = result.body
            resource.tags = {} if resource.tags.nil?
            resource.tags[tag_name] = tag_value
            promise = @rmc.resources.create_or_update(resource_group_name, resource_provider_namespace, parent_resource_id, resource_type, resource_name, API_VERSION, resource)
            promise.value!
            Fog::Logger.debug "Tag #{tag_name} created successfully for Resource #{resource_name}"
            true
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def tag_resource(_resource_id, tag_name, _tag_value)
          Fog::Logger.debug "Tag #{tag_name} created successfully for Resource 'resource_name'"
          true
        end
      end
    end
  end
end
