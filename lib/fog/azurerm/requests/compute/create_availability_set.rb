# rubocop:disable AbcSize
# rubocop:disable MethodLength
module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_availability_set(resource_group, name, params)
          begin
            promise = @compute_mgmt_client.availability_sets.create_or_update(resource_group, name, params)
            promise.value!
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Availability Set #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_availability_set(resource_group, name, params)
        end
      end
    end
  end
end
