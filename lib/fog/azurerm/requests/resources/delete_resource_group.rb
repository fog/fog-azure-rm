module Fog
  module Resources
    class AzureRM
      class Real
        def delete_resource_group(name)
          begin
            Fog::Logger.debug "Deleting Resource Group: #{name}."
            promise = @rmc.resource_groups.delete(name)
            result = promise.value!
            Fog::Logger.debug "Resource Group #{name} deleted successfully."
            result
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Resource Group #{name}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      class Mock
        def delete_resource_group(name)
        end
      end
    end
  end
end
