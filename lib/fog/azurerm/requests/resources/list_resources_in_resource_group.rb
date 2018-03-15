module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_resources_in_resource_group(resource_group_name)
          msg = "Listing Resources in #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            resources = @rmc.resource_groups.list_resources(resource_group_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Resources in #{resource_group_name} listed successfully"
          resources
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def list_resources_in_resource_group(*)
          resources = {
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
          result_mapper = Azure::ARM::Resources::Models::GenericResource.mapper
          @rmc.deserialize(result_mapper, resources, 'result.body').value
        end
      end
    end
  end
end
