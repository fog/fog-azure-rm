module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def tag_resource(resource_id, tag_name, tag_value, api_version = API_VERSION, async = false)
          split_resource = resource_id.split('/') unless resource_id.nil?
          if split_resource.count != 9
            raise 'Invalid Resource Id'
          end

          resource_group_name = get_resource_from_resource_id(resource_id, RESOURCE_GROUP_NAME)
          resource_provider_namespace = get_resource_from_resource_id(resource_id, RESOURCE_PROVIDER_NAMESPACE)
          resource_type = get_resource_from_resource_id(resource_id, RESOURCE_TYPE)
          resource_name = get_resource_from_resource_id(resource_id, RESOURCE_NAME)
          parent_resource_id = ''

          msg = "Creating Tag #{tag_name} for Resource #{resource_name}"
          Fog::Logger.debug msg

          begin
            resource = @rmc.resources.get(resource_group_name, resource_provider_namespace, parent_resource_id, resource_type, resource_name, api_version)
            resource.tags = {} if resource.tags.nil?
            resource.tags[tag_name] = tag_value

            if async
              @rmc.resources.create_or_update_async(resource_group_name, resource_provider_namespace, parent_resource_id, resource_type, resource_name, api_version, resource, nil)
            else
              @rmc.resources.create_or_update(resource_group_name, resource_provider_namespace, parent_resource_id, resource_type, resource_name, api_version, resource)
            end
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Tag #{tag_name} created successfully for Resource #{resource_name}"
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def tag_resource(_resource_id, tag_name, _tag_value, _api_version)
          Fog::Logger.debug "Tag #{tag_name} created successfully for Resource 'resource_name'"
          true
        end
      end
    end
  end
end
