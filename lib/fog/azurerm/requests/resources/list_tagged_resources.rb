module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_tagged_resources(tag_name, tag_value = nil)
          Fog::Logger.debug "Listing Resources with tagname: #{tag_name}"

          unless tag_name.nil?
            query_filter = "tagname eq '#{tag_name}' "
            query_filter += tag_value.nil? ? '' : "and tagvalue eq '#{tag_value}'"
            begin
              unless tag_name.nil?
                query_filter = "tagname eq '#{tag_name}' "
                query_filter += tag_value.nil? ? '' : "and tagvalue eq '#{tag_value}'"
                resources = @rmc.resources.list_as_lazy(query_filter)
                resources.next_link = ''
                result_mapper = Azure::ARM::Resources::Models::ResourceListResult.mapper
                @rmc.serialize(result_mapper, resources, 'parameters')['value']
              end
            rescue MsRestAzure::AzureOperationError => e
              raise Fog::AzureRm::OperationError.new(e)
            end
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
