module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_resource_group(name, location)
          begin
            Fog::Logger.debug "Creating Resource Group: #{name}."
            rg_properties = ::Azure::ARM::Resources::Models::ResourceGroup.new
            rg_properties.location = location
            promise = @rmc.resource_groups.create_or_update(name, rg_properties)
            result = promise.value!
            Fog::Logger.debug "Resource Group #{name} created successfully."
            Azure::ARM::Resources::Models::ResourceGroup.serialize_object(result.body)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception creating Resource Group #{name}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_resource_group(name, location)
          {
            'location' => location,
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{name}",
            'name' => name,
            'properties' =>
            {
              'provisioningState' => 'Succeeded'
            }
          }
        end
      end
    end
  end
end
