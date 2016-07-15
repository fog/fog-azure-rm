module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_resource_tag(resource_id, tag_name, tag_value)
          begin

            split_resource = resource_id.split('/') unless resource_id.nil?
            if split_resource.count != 9
              msg = 'Invalid Resource Id.'
              raise msg
            end
            resource_group_name = split_resource[4]
            resource_provider_namespace = split_resource[6]
            resource_type = split_resource[7]
            resource_name = split_resource[8]
            api_version = '2016-06-01'

            Fog::Logger.debug "Deleting Tag #{tag_name} from Resource #{resource_name}"
            promise = @rmc.resources.get(resource_group_name, resource_provider_namespace, '', resource_type, resource_name, api_version)
            result = promise.value!
            resource = result.body

            if resource.tags.key?(tag_name)
              resource.tags.delete_if { |key, value| key == tag_name && value == tag_value }
            end
            promise = @rmc.resources.create_or_update(resource_group_name, resource_provider_namespace, '', resource_type, resource_name, api_version, resource)
            promise.value!
            Fog::Logger.debug "Tag #{tag_name} deleted successfully from Resource #{resource_name}"
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Tag #{tag_name}. #{e.body['error']['message']}"
            raise msg
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
