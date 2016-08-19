module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_resource_group(name, location)
          Fog::Logger.debug "Creating Resource Group: #{name}."
          resource_group = Azure::ARM::Resources::Models::ResourceGroup.new
          resource_group.location = location
          begin
            resource_group = @rmc.resource_groups.create_or_update(name, resource_group)
            Fog::Logger.debug "Resource Group #{name} created successfully."
            resource_group
          rescue  MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_resource_group(name, location)
          resource_group = {
            'location' => location,
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{name}",
            'name' => name,
            'properties' =>
            {
              'provisioningState' => 'Succeeded'
            }
          }
          result_mapper = Azure::ARM::Resources::Models::ResourceGroup.mapper
          @rmc.deserialize(result_mapper, resource_group, 'result.body')
        end
      end
    end
  end
end
