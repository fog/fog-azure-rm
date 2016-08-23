module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_availability_set(resource_group, name)
          msg = "Deleting Availability Set: #{name}."
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.availability_sets.delete(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Availability Set #{name} deleted successfully."
          true
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_availability_set(resource_group, name)
          Fog::Logger.debug "Availability Set #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
