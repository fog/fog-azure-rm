module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_availability_sets(resource_group)
          begin
            promise = @compute_mgmt_client.availability_sets.list(resource_group)
            response = promise.value!
            Azure::ARM::Compute::Models::AvailabilitySetListResult.serialize_object(response.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing availability sets in Resource Group #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_availability_sets(resource_group)
        end
      end
    end
  end
end
