module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_availability_set_exists(resource_group, name)
          msg = "Checking Availability set: #{name}"
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.availability_sets.get(resource_group, name)
            Fog::Logger.debug "Availability set #{name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if check_resource_existence_exception(e)
              raise_azure_exception(e, msg)
            else
              Fog::Logger.debug "Availability set #{name} doesn't exist."
              false
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_availability_set_exists(_resource_group, _name)
          true
        end
      end
    end
  end
end
