module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_resource_group(name)
          msg = "Deleting Resource Group: #{name}."
          Fog::Logger.debug msg
          begin
            @rmc.resource_groups.delete(name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Resource Group #{name} deleted successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_resource_group(name)
          Fog::Logger.debug "Resource Group #{name} deleted successfully."
          true
        end
      end
    end
  end
end
