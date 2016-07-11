module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def tag_resource(resource_id, tag_name, tag_value)
          begin
            split_resource = resource_id.split('/') unless resource_id.nil?
            if split_resource.count != 9
              msg = 'Invalid Resource Id.'
              raise msg
            end
            resource_group_name = split_resource[4]
            resource_provider_namespace = split_resource[6]
            parent_resource_id = ''
            resource_type = split_resource[7]
            resource_name = split_resource[8]
            api_version = '2016-06-01'

            Fog::Logger.debug "Creating Tag #{tag_name} for Resource #{resource_name}"
            promise = @rmc.resources.get(resource_group_name, resource_provider_namespace, parent_resource_id, resource_type, resource_name, api_version)
            result = promise.value!
            resource = result.body
            resource.tags = {} if resource.tags.nil?
            resource.tags[tag_name] = tag_value
            promise = @rmc.resources.create_or_update(resource_group_name, resource_provider_namespace, parent_resource_id, resource_type, resource_name, api_version, resource)
            response = promise.value!
            Fog::Logger.debug "Tag #{tag_name} created successfully for Resource #{resource_name}"
            Azure::ARM::Resources::Models::GenericResource.serialize_object(response.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Tag #{tag_name}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def tag_resource(resource_id, tag_name, tag_value)
          {
            'id' => resource_id,
            'name' => 'your-resource-name',
            'type' => 'providernamespace/resourcetype',
            'location' => 'westus',
            'tags' =>
              {
                tag_name => tag_value
              },
            'plan' =>
              {
                'name' => 'free'
              }
          }
        end
      end
    end
  end
end
