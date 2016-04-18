module Fog
  module Resources
    class AzureRM
      class Real
        def create_resource_group(name, parameters)
          begin
            promise = @rmc.resource_groups.create_or_update(name, parameters)
            promise.value!
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception creating Resource Group #{name}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      class Mock
        def create_resource_group(name, parameters)
        end
      end
    end
  end
end
