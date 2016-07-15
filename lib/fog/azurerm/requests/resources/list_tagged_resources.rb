module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_tagged_resources(tag_name, tag_value = nil)
          begin
            unless tag_name.nil?
              query_filter = "tagname eq '#{tag_name}' "
              query_filter += tag_value.nil? ? '' : "and tagvalue eq '#{tag_value}'"
              promise = @rmc.resources.list(query_filter)
              result = promise.value!
              result.body.next_link = ''
              Azure::ARM::Resources::Models::ResourceListResult.serialize_object(result.body)['value']
            end
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Resources . #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def list_tagged_resources(tag_name, tag_value)
          [
            {
              'id' => _resource_id,
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
          ]
        end
      end
    end
  end
end
