module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_tagged_resources(tag_name, tag_value = nil)
          Fog::Logger.debug 'Listing Tagged Resources'
          begin
            unless tag_name.nil?
              query_filter = "tagname eq '#{tag_name}' "
              query_filter += tag_value.nil? ? '' : "and tagvalue eq '#{tag_value}'"
              resources = @rmc.resources.list_as_lazy(query_filter)
              resources.next_link = ''
              Fog::Logger.debug 'Tagged Resources listed successfully'
              resources.value
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
          {
            'value' => [
              {
                'id' => '/subscriptions/########-####-####-####-############/fog-rg',
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
          }
          result_mapper = Azure::ARM::Resources::Models::ResourceListResult.mapper
          @rmc.deserialize(result_mapper, resources, 'result.body').value
        end
      end
    end
  end
end
